//
//  MealVarietyViewController.m
//  Squad
//
//  Created by AQB Solutions-Mac Mini 2 on 29/03/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import "MealVarietyViewController.h"
#import "DietaryPreferenceViewController.h"
#import "Utility.h"
#import "NutritionSettingHomeViewController.h"
#import "MealFrequencyViewController.h"
#import "MealPlanViewController.h"
#import "MasterMenuViewController.h"
#define mealBreakfastType  @{@"1":@"Same_Everyday",@"3":@"Different2_3",@"7":@"Different_Daily"}
#define mealDinnerLunchSnackType  @{@"1":@"Same_Everyday",@"3":@"Different2_3",@"5":@"Different5",@"7":@"Different_Daily"}


@interface MealVarietyViewController ()
{
    IBOutlet NSLayoutConstraint *footerConstant;
    IBOutlet UIButton *menuButton;
    IBOutlet UIButton *sameMealEverydayB;
    IBOutlet UIButton *differentMealsB;
    IBOutlet UIButton *differentDailyB;
    
    IBOutlet UIButton *sameMealEverydayL;
    IBOutlet UIButton *differentMealsL;
    IBOutlet UIButton *differentDailyL;
    IBOutlet UIButton *fiveDifferentMealsL;
    
    IBOutlet UIButton *sameMealEverydayD;
    IBOutlet UIButton *differentMealsD;
    IBOutlet UIButton *differentDailyD;
    IBOutlet UIButton *fiveDifferentMealsD;
    
    IBOutlet UIButton *sameMealEverydayS;
    IBOutlet UIButton *differentMealsS;
    IBOutlet UIButton *differentDailyS;
    IBOutlet UIButton *fiveDifferentMealsS;
    IBOutlet UIButton *backToNutritionSettings;
    IBOutlet NSLayoutConstraint *backToNutritionSettingsButtonHeightConstant;
    IBOutlet NSLayoutConstraint *mealCategoryHeightConstraint;

    IBOutlet NSLayoutConstraint *noMeasureContainerHeightConstraint;
    
    //add_16/8/17
    IBOutlet UILabel *standardMeasureLabel;
    IBOutlet UITextView *descriptionTextView;
    
    IBOutlet UIView *sameMealEverydayBView;
    IBOutlet UIView *differentMealsBView;
    IBOutlet UIView *differentDailyBiew;
    
    IBOutlet UIView *sameMealEverydayLView;
    IBOutlet UIView *differentMealsLView;
    IBOutlet UIView *differentDailyLiew;
    IBOutlet UIView *fiveDifferentMealsLView;
    
    IBOutlet UIView *sameMealEverydayDView;
    IBOutlet UIView *differentMealsDView;
    IBOutlet UIView *differentDailyDiew;
    IBOutlet UIView *fiveDifferentMealsDiew;

    
    IBOutlet UIView *sameMealEverydaySView;
    IBOutlet UIView *differentMealsSView;
    IBOutlet UIView *differentDailySiew;
    IBOutlet UIView *fiveDifferentMealsSiew;
    
    
    IBOutlet UILabel *sameMealEverydayBLabel;
    IBOutlet UILabel *differentMealsBLabel;
    IBOutlet UILabel *differentDailyBLabel;
    
    IBOutlet UILabel *sameMealEverydaylLabel;
    IBOutlet UILabel *differentMealslLabel;
    IBOutlet UILabel *fiveDifferentMealslLabel;
    IBOutlet UILabel *differentDailylLabel;

    IBOutlet UILabel *sameMealEverydayDLabel;
    IBOutlet UILabel *differentMealsDLabel;
    IBOutlet UILabel *fiveDifferentMealsDLabel;
    IBOutlet UILabel *differentDailyDLabel;

    IBOutlet UILabel *sameMealEverydaySLabel;
    IBOutlet UILabel *differentMealsSLabel;
    IBOutlet UILabel *fiveDifferentMealsSLabel;
    IBOutlet UILabel *differentDailySLabel;

    int standard;//add_16/8/17
    int nomeasure;//add_16/8/17
    NSMutableDictionary *MealClassifiedUserMap;

    
    IBOutlet UISegmentedControl *noMeasureSegmentedButton;
    IBOutlet UIView *blankView;
    UIView *contentView;
    int snackUpdateValue;
    int dinnerUpdateValue;
    int lunchUpdateValue;
    int breakfastUpadteValue;
    int stepnumber;
    int apiCount;
    BOOL isSaveDefault;
    BOOL isDefault;
}
@end

@implementation MealVarietyViewController

#pragma mark  -IBAction
- (IBAction)noMeasureValueChange:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == 0) {
        standard = 100;
        nomeasure = 0;
    }else if (sender.selectedSegmentIndex == 1) {
        noMeasureSegmentedButton.selectedSegmentIndex = 1;
        standard = 75;
        nomeasure = 25;
    }else if (sender.selectedSegmentIndex == 2) {
        noMeasureSegmentedButton.selectedSegmentIndex = 2;
        standard = 50;
        nomeasure = 50;
    }else if (sender.selectedSegmentIndex == 3) {
        noMeasureSegmentedButton.selectedSegmentIndex = 3;
        standard = 25;
        nomeasure = 75;
    }else if(sender.selectedSegmentIndex == 4){
        noMeasureSegmentedButton.selectedSegmentIndex = 4;
        standard = 0;
        nomeasure = 100;
    }
    NSString *str = [@"" stringByAppendingFormat:@"Standard %d",standard];
    str = [str stringByAppendingString:@"% - "];
    str = [str stringByAppendingFormat:@"%d",nomeasure];
    str = [str stringByAppendingString:@"% No Measure"];
    standardMeasureLabel.text = str;
    isSaveDefault=false;
    [self webServiceCall_SaveUserMealVariety];
}

- (IBAction)menuTapped:(id)sender {
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
    [self.slidingViewController resetTopViewAnimated:YES];
}

- (IBAction)previousbuttonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)logoTapped:(id)sender {
    [self.navigationController  popToRootViewControllerAnimated:YES];
}

- (IBAction)nextbuttonPressed:(id)sender {
    if (isSaveDefault) {
        if (sameMealEverydayB.selected) {
            breakfastUpadteValue =1;
        }else if(differentMealsB.selected) {
            breakfastUpadteValue =3;
        }else if(differentDailyB.selected) {
            breakfastUpadteValue =7;
        }
        if (sameMealEverydayL.selected) {
            lunchUpdateValue =1;
        }else if(differentMealsL.selected) {
            lunchUpdateValue =3;
        }else if(fiveDifferentMealsL.selected) {
            lunchUpdateValue =5;
        }else if(differentDailyL.selected) {
            lunchUpdateValue =7;
        }
        if (sameMealEverydayD.selected) {
            dinnerUpdateValue =1;
        }else if(differentMealsD.selected) {
            dinnerUpdateValue =3;
        }else if(fiveDifferentMealsD.selected) {
            dinnerUpdateValue =5;
        }else if(differentDailyD.selected) {
            dinnerUpdateValue =7;
        }
        if (sameMealEverydayS.selected) {
            snackUpdateValue =1;
        }else if(differentMealsS.selected) {
            snackUpdateValue =3;
        }else if(fiveDifferentMealsS.selected) {
            snackUpdateValue =5;
        }else if(differentDailyS.selected) {
            snackUpdateValue =7;
        }
        isDefault =true;
        if(nomeasure == 0 && standard==0){//22 april 19
            nomeasure = 0; //add_16/8/17
            standard = 100; //add_16/8/17
        }
        [self webServiceCall_SaveUserMealVariety];
    }else{
        if (!(stepnumber == 0)) {
            [self webSerViceCall_UpdateNutrationStep:true];
        }else{
            MealPlanViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MealPlanView"];
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
-(IBAction)breakyButtonPressed:(UIButton*)sender{
    
    if (sender.tag ==0) {
        sameMealEverydayB.selected = true;
        sameMealEverydayBView.backgroundColor = [Utility colorWithHexString:@"E425A0"];
        sameMealEverydayBLabel.textColor = [UIColor whiteColor];
        
        differentMealsB.selected = false;
        differentMealsBView.backgroundColor = [UIColor whiteColor];
        differentMealsBLabel.textColor = [Utility colorWithHexString:@"E425A0"];
        
        differentDailyB.selected = false;
        differentDailyBiew.backgroundColor = [UIColor whiteColor];
        differentDailyBLabel.textColor = [Utility colorWithHexString:@"E425A0"];
        
//        [sameMealEverydayB setImage:[UIImage imageNamed:@"checkbox_recip.png"] forState:UIControlStateNormal];
//        [differentMealsB setImage:[UIImage imageNamed:@"uncheckbox_recip.png"] forState:UIControlStateNormal];
//        [differentDailyB setImage:[UIImage imageNamed:@"uncheckbox_recip.png"] forState:UIControlStateNormal];
    }else if (sender.tag ==1){
        
        sameMealEverydayB.selected = false;
        sameMealEverydayBView.backgroundColor = [UIColor whiteColor];
        sameMealEverydayBLabel.textColor = [Utility colorWithHexString:@"E425A0"];
        
        differentMealsB.selected = true;
        differentMealsBView.backgroundColor = [Utility colorWithHexString:@"E425A0"];
        differentMealsBLabel.textColor = [UIColor whiteColor];
        
        differentDailyB.selected = false;
        differentDailyBiew.backgroundColor = [UIColor whiteColor];
        differentDailyBLabel.textColor = [Utility colorWithHexString:@"E425A0"];
        
//        [sameMealEverydayB setImage:[UIImage imageNamed:@"uncheckbox_recip.png"] forState:UIControlStateNormal];
//        [differentMealsB setImage:[UIImage imageNamed:@"checkbox_recip.png"] forState:UIControlStateNormal];
//        [differentDailyB setImage:[UIImage imageNamed:@"uncheckbox_recip.png"] forState:UIControlStateNormal];
    }else if (sender.tag ==2){
        sameMealEverydayB.selected = false;
        sameMealEverydayBView.backgroundColor = [UIColor whiteColor];
        sameMealEverydayBLabel.textColor = [Utility colorWithHexString:@"E425A0"];
        
        differentMealsB.selected = false;
        differentMealsBView.backgroundColor = [UIColor whiteColor];
        differentMealsBLabel.textColor = [Utility colorWithHexString:@"E425A0"];
        
        differentDailyB.selected = true;
        differentDailyBiew.backgroundColor = [Utility colorWithHexString:@"E425A0"];
        differentDailyBLabel.textColor = [UIColor whiteColor];
        
//        [sameMealEverydayB setImage:[UIImage imageNamed:@"uncheckbox_recip.png"] forState:UIControlStateNormal];
//        [differentMealsB setImage:[UIImage imageNamed:@"uncheckbox_recip.png"] forState:UIControlStateNormal];
//        [differentDailyB setImage:[UIImage imageNamed:@"checkbox_recip.png"] forState:UIControlStateNormal];
    }
    if (sameMealEverydayB.selected) {
        breakfastUpadteValue =1;
    }else if(differentMealsB.selected) {
        breakfastUpadteValue =3;
    }else if(differentDailyB.selected) {
        breakfastUpadteValue =7;
    }
    isSaveDefault=false;
    [self webServiceCall_SaveUserMealVariety];
    
}
-(IBAction)lunchButtonPressed:(UIButton*)sender{
    if (sender.tag ==3) {
        
        sameMealEverydayL.selected = true;
        sameMealEverydayLView.backgroundColor = [Utility colorWithHexString:@"E425A0"];
        sameMealEverydaylLabel.textColor = [UIColor whiteColor];
        
        differentMealsL.selected = false;
        differentMealsLView.backgroundColor = [UIColor whiteColor];
        differentMealslLabel.textColor = [Utility colorWithHexString:@"E425A0"];
        
        differentDailyL.selected = false;
        differentDailyLiew.backgroundColor = [UIColor whiteColor];
        differentDailylLabel.textColor = [Utility colorWithHexString:@"E425A0"];
        
        fiveDifferentMealsL.selected = false;
        fiveDifferentMealsLView.backgroundColor = [UIColor whiteColor];
        fiveDifferentMealslLabel.textColor = [Utility colorWithHexString:@"E425A0"];
        
//        [sameMealEverydayL setImage:[UIImage imageNamed:@"checkbox_recip.png"] forState:UIControlStateNormal];
//        [differentMealsL setImage:[UIImage imageNamed:@"uncheckbox_recip.png"] forState:UIControlStateNormal];
//        [fiveDifferentMealsL setImage:[UIImage imageNamed:@"uncheckbox_recip.png"] forState:UIControlStateNormal];
//        [differentDailyL setImage:[UIImage imageNamed:@"uncheckbox_recip.png"] forState:UIControlStateNormal];
    }else if (sender.tag ==4){
        
        sameMealEverydayL.selected = false;
        sameMealEverydayLView.backgroundColor = [UIColor whiteColor];
        sameMealEverydaylLabel.textColor = [Utility colorWithHexString:@"E425A0"];
        
        differentMealsL.selected = true;
        differentMealsLView.backgroundColor = [Utility colorWithHexString:@"E425A0"];
        differentMealslLabel.textColor = [UIColor whiteColor];
        
        fiveDifferentMealsL.selected = false;
        fiveDifferentMealsLView.backgroundColor = [UIColor whiteColor];
        fiveDifferentMealslLabel.textColor = [Utility colorWithHexString:@"E425A0"];
        
        
        differentDailyL.selected = false;
        differentDailyLiew.backgroundColor = [UIColor whiteColor];
        differentDailylLabel.textColor = [Utility colorWithHexString:@"E425A0"];
        
//        [sameMealEverydayL setImage:[UIImage imageNamed:@"uncheckbox_recip.png"] forState:UIControlStateNormal];
//        [differentMealsL setImage:[UIImage imageNamed:@"checkbox_recip.png"] forState:UIControlStateNormal];
//        [fiveDifferentMealsL setImage:[UIImage imageNamed:@"uncheckbox_recip.png"] forState:UIControlStateNormal];
//        [differentDailyL setImage:[UIImage imageNamed:@"uncheckbox_recip.png"] forState:UIControlStateNormal];
    }else if (sender.tag ==5){
        
        sameMealEverydayL.selected = false;
        sameMealEverydayLView.backgroundColor = [UIColor whiteColor];
        sameMealEverydaylLabel.textColor = [Utility colorWithHexString:@"E425A0"];
        
        differentMealsL.selected = false;
        differentMealsLView.backgroundColor = [UIColor whiteColor];
        differentMealslLabel.textColor = [Utility colorWithHexString:@"E425A0"];
        
        fiveDifferentMealsL.selected = true;
        fiveDifferentMealsLView.backgroundColor = [Utility colorWithHexString:@"E425A0"];
        fiveDifferentMealslLabel.textColor = [UIColor whiteColor];
        
        differentDailyL.selected = false;
        differentDailyLiew.backgroundColor = [UIColor whiteColor];
        differentDailylLabel.textColor = [Utility colorWithHexString:@"E425A0"];
        
//        [sameMealEverydayL setImage:[UIImage imageNamed:@"uncheckbox_recip.png"] forState:UIControlStateNormal];
//        [differentMealsL setImage:[UIImage imageNamed:@"uncheckbox_recip.png"] forState:UIControlStateNormal];
//        [fiveDifferentMealsL setImage:[UIImage imageNamed:@"checkbox_recip.png"] forState:UIControlStateNormal];
//        [differentDailyL setImage:[UIImage imageNamed:@"uncheckbox_recip.png"] forState:UIControlStateNormal];
    }else if (sender.tag ==6){
        
        sameMealEverydayL.selected = false;
        sameMealEverydayLView.backgroundColor = [UIColor whiteColor];
        sameMealEverydaylLabel.textColor = [Utility colorWithHexString:@"E425A0"];
        
        differentMealsL.selected = false;
        differentMealsLView.backgroundColor = [UIColor whiteColor];
        differentMealslLabel.textColor = [Utility colorWithHexString:@"E425A0"];
        
        fiveDifferentMealsL.selected = false;
        fiveDifferentMealsLView.backgroundColor = [UIColor whiteColor];
        fiveDifferentMealslLabel.textColor = [Utility colorWithHexString:@"E425A0"];
        
        differentDailyL.selected = true;
        differentDailyLiew.backgroundColor = [Utility colorWithHexString:@"E425A0"];
        differentDailylLabel.textColor = [UIColor whiteColor];
        
//        [sameMealEverydayL setImage:[UIImage imageNamed:@"uncheckbox_recip.png"] forState:UIControlStateNormal];
//        [differentMealsL setImage:[UIImage imageNamed:@"uncheckbox_recip.png"] forState:UIControlStateNormal];
//        [fiveDifferentMealsL setImage:[UIImage imageNamed:@"uncheckbox_recip.png"] forState:UIControlStateNormal];
//        [differentDailyL setImage:[UIImage imageNamed:@"checkbox_recip.png"] forState:UIControlStateNormal];
    }
    if (sameMealEverydayL.selected) {
        lunchUpdateValue =1;
    }else if(differentMealsL.selected) {
        lunchUpdateValue =3;
    }else if(fiveDifferentMealsL.selected) {
        lunchUpdateValue =5;
    }else if(differentDailyL.selected) {
        lunchUpdateValue =7;
    }
    isSaveDefault=false;
    [self webServiceCall_SaveUserMealVariety];

}
-(IBAction)dinnerButtonPressed:(UIButton*)sender{
    if (sender.tag ==7) {
        sameMealEverydayD.selected = true;
        sameMealEverydayDView.backgroundColor = [Utility colorWithHexString:@"E425A0"];
        sameMealEverydayDLabel.textColor = [UIColor whiteColor];
        
        differentMealsD.selected = false;
        differentMealsDView.backgroundColor = [UIColor whiteColor];
        differentMealsDLabel.textColor = [Utility colorWithHexString:@"E425A0"];
        
        fiveDifferentMealsD.selected = false;
        fiveDifferentMealsDiew.backgroundColor = [UIColor whiteColor];
        fiveDifferentMealsDLabel.textColor = [Utility colorWithHexString:@"E425A0"];
        
        differentDailyD.selected = false;
        differentDailyDiew.backgroundColor = [UIColor whiteColor];
        differentDailyDLabel.textColor = [Utility colorWithHexString:@"E425A0"];
//        [sameMealEverydayD setImage:[UIImage imageNamed:@"checkbox_recip.png"] forState:UIControlStateNormal];
//        [differentMealsD setImage:[UIImage imageNamed:@"uncheckbox_recip.png"] forState:UIControlStateNormal];
//        [fiveDifferentMealsD setImage:[UIImage imageNamed:@"uncheckbox_recip.png"] forState:UIControlStateNormal];
//        [differentDailyD setImage:[UIImage imageNamed:@"uncheckbox_recip.png"] forState:UIControlStateNormal];
    }else if (sender.tag ==8){
        sameMealEverydayD.selected = false;
        sameMealEverydayDView.backgroundColor = [UIColor whiteColor];
        sameMealEverydayDLabel.textColor = [Utility colorWithHexString:@"E425A0"];
        
        differentMealsD.selected = true;
        differentMealsDView.backgroundColor = [Utility colorWithHexString:@"E425A0"];
        differentMealsDLabel.textColor = [UIColor whiteColor];
        
        fiveDifferentMealsD.selected = false;
        fiveDifferentMealsDiew.backgroundColor = [UIColor whiteColor];
        fiveDifferentMealsDLabel.textColor = [Utility colorWithHexString:@"E425A0"];
        
        differentDailyD.selected = false;
        differentDailyDiew.backgroundColor = [UIColor whiteColor];
        differentDailyDLabel.textColor = [Utility colorWithHexString:@"E425A0"];
        
//        [sameMealEverydayD setImage:[UIImage imageNamed:@"uncheckbox_recip.png"] forState:UIControlStateNormal];
//        [differentMealsD setImage:[UIImage imageNamed:@"checkbox_recip.png"] forState:UIControlStateNormal];
//        [fiveDifferentMealsD setImage:[UIImage imageNamed:@"uncheckbox_recip.png"] forState:UIControlStateNormal];
//        [differentDailyD setImage:[UIImage imageNamed:@"uncheckbox_recip.png"] forState:UIControlStateNormal];
    }else if (sender.tag ==9){
        sameMealEverydayD.selected = false;
        sameMealEverydayDView.backgroundColor = [UIColor whiteColor];
        sameMealEverydayDLabel.textColor = [Utility colorWithHexString:@"E425A0"];
        
        differentMealsD.selected = false;
        differentMealsDView.backgroundColor = [UIColor whiteColor];
        differentMealsDLabel.textColor = [Utility colorWithHexString:@"E425A0"];
        
        fiveDifferentMealsD.selected = true;
        fiveDifferentMealsDiew.backgroundColor = [Utility colorWithHexString:@"E425A0"];
        fiveDifferentMealsDLabel.textColor = [UIColor whiteColor];
        
        differentDailyD.selected = false;
        differentDailyDiew.backgroundColor = [UIColor whiteColor];
        differentDailyDLabel.textColor = [Utility colorWithHexString:@"E425A0"];
        
//        [sameMealEverydayD setImage:[UIImage imageNamed:@"uncheckbox_recip.png"] forState:UIControlStateNormal];
//        [differentMealsD setImage:[UIImage imageNamed:@"uncheckbox_recip.png"] forState:UIControlStateNormal];
//        [fiveDifferentMealsD setImage:[UIImage imageNamed:@"checkbox_recip.png"] forState:UIControlStateNormal];
//        [differentDailyD setImage:[UIImage imageNamed:@"uncheckbox_recip.png"] forState:UIControlStateNormal];
    }else if (sender.tag ==10){
        sameMealEverydayD.selected = false;
        sameMealEverydayDView.backgroundColor = [UIColor whiteColor];
        sameMealEverydayDLabel.textColor = [Utility colorWithHexString:@"E425A0"];
        
        differentMealsD.selected = false;
        differentMealsDView.backgroundColor = [UIColor whiteColor];
        differentMealsDLabel.textColor = [Utility colorWithHexString:@"E425A0"];
        
        fiveDifferentMealsD.selected = false;
        fiveDifferentMealsDiew.backgroundColor = [UIColor whiteColor];
        fiveDifferentMealsDLabel.textColor = [Utility colorWithHexString:@"E425A0"];
        
        differentDailyD.selected = true;
        differentDailyDiew.backgroundColor = [Utility colorWithHexString:@"E425A0"];
        differentDailyDLabel.textColor = [UIColor whiteColor];
        
//        [sameMealEverydayD setImage:[UIImage imageNamed:@"uncheckbox_recip.png"] forState:UIControlStateNormal];
//        [differentMealsD setImage:[UIImage imageNamed:@"uncheckbox_recip.png"] forState:UIControlStateNormal];
//        [fiveDifferentMealsD setImage:[UIImage imageNamed:@"uncheckbox_recip.png"] forState:UIControlStateNormal];
//        [differentDailyD setImage:[UIImage imageNamed:@"checkbox_recip.png"] forState:UIControlStateNormal];
    }
    if (sameMealEverydayD.selected) {
        dinnerUpdateValue =1;
    }else if(differentMealsD.selected) {
        dinnerUpdateValue =3;
    }else if(fiveDifferentMealsD.selected) {
        dinnerUpdateValue =5;
    }else if(differentDailyD.selected) {
        dinnerUpdateValue =7;
    }
    isSaveDefault=false;
    [self webServiceCall_SaveUserMealVariety];
    
}
-(IBAction)snackButtonPressed:(UIButton*)sender{
    if (sender.tag ==11) {
        
        sameMealEverydayS.selected = true;
        sameMealEverydaySView.backgroundColor = [Utility colorWithHexString:@"E425A0"];
        sameMealEverydaySLabel.textColor = [UIColor whiteColor];
        
        differentMealsS.selected = false;
        differentMealsSView.backgroundColor = [UIColor whiteColor];
        differentMealsSLabel.textColor = [Utility colorWithHexString:@"E425A0"];
        
        fiveDifferentMealsS.selected = false;
        fiveDifferentMealsSiew.backgroundColor = [UIColor whiteColor];
        fiveDifferentMealsSLabel.textColor = [Utility colorWithHexString:@"E425A0"];
        
        differentDailyS.selected = false;
        differentDailySiew.backgroundColor = [UIColor whiteColor];
        differentDailySLabel.textColor = [Utility colorWithHexString:@"E425A0"];
        
//        [sameMealEverydayS setImage:[UIImage imageNamed:@"checkbox_recip.png"] forState:UIControlStateNormal];
//        [differentMealsS setImage:[UIImage imageNamed:@"uncheckbox_recip.png"] forState:UIControlStateNormal];
//        [fiveDifferentMealsS setImage:[UIImage imageNamed:@"uncheckbox_recip.png"] forState:UIControlStateNormal];
//        [differentDailyS setImage:[UIImage imageNamed:@"uncheckbox_recip.png"] forState:UIControlStateNormal];
    }else if (sender.tag ==12){
        sameMealEverydayS.selected = false;
        sameMealEverydaySView.backgroundColor = [UIColor whiteColor];
        sameMealEverydaySLabel.textColor = [Utility colorWithHexString:@"E425A0"];
        
        differentMealsS.selected = true;
        differentMealsSView.backgroundColor = [Utility colorWithHexString:@"E425A0"];
        differentMealsSLabel.textColor = [UIColor whiteColor];
        
        fiveDifferentMealsS.selected = false;
        fiveDifferentMealsSiew.backgroundColor = [UIColor whiteColor];
        fiveDifferentMealsSLabel.textColor = [Utility colorWithHexString:@"E425A0"];
        
        differentDailyS.selected = false;
        differentDailySiew.backgroundColor = [UIColor whiteColor];
        differentDailySLabel.textColor = [Utility colorWithHexString:@"E425A0"];
//        [sameMealEverydayS setImage:[UIImage imageNamed:@"uncheckbox_recip.png"] forState:UIControlStateNormal];
//        [differentMealsS setImage:[UIImage imageNamed:@"checkbox_recip.png"] forState:UIControlStateNormal];
//        [fiveDifferentMealsS setImage:[UIImage imageNamed:@"uncheckbox_recip.png"] forState:UIControlStateNormal];
//        [differentDailyS setImage:[UIImage imageNamed:@"uncheckbox_recip.png"] forState:UIControlStateNormal];
    }else if (sender.tag ==13){
        
        sameMealEverydayS.selected = false;
        sameMealEverydaySView.backgroundColor = [UIColor whiteColor];
        sameMealEverydaySLabel.textColor = [Utility colorWithHexString:@"E425A0"];
        
        differentMealsS.selected = false;
        differentMealsSView.backgroundColor = [UIColor whiteColor];
        differentMealsSLabel.textColor = [Utility colorWithHexString:@"E425A0"];
        
        fiveDifferentMealsS.selected = true;
        fiveDifferentMealsSiew.backgroundColor = [Utility colorWithHexString:@"E425A0"];
        fiveDifferentMealsSLabel.textColor = [UIColor whiteColor];
        
        differentDailyS.selected = false;
        differentDailySiew.backgroundColor = [UIColor whiteColor];
        differentDailySLabel.textColor = [Utility colorWithHexString:@"E425A0"];
        
//        [sameMealEverydayS setImage:[UIImage imageNamed:@"uncheckbox_recip.png"] forState:UIControlStateNormal];
//        [differentMealsS setImage:[UIImage imageNamed:@"uncheckbox_recip.png"] forState:UIControlStateNormal];
//        [fiveDifferentMealsS setImage:[UIImage imageNamed:@"checkbox_recip.png"] forState:UIControlStateNormal];
//        [differentDailyS setImage:[UIImage imageNamed:@"uncheckbox_recip.png"] forState:UIControlStateNormal];
    }else if (sender.tag ==14){
        
        sameMealEverydayS.selected = false;
        sameMealEverydaySView.backgroundColor = [UIColor whiteColor];
        sameMealEverydaySLabel.textColor = [Utility colorWithHexString:@"E425A0"];
        
        differentMealsS.selected = false;
        differentMealsSView.backgroundColor = [UIColor whiteColor];
        differentMealsSLabel.textColor = [Utility colorWithHexString:@"E425A0"];
        
        fiveDifferentMealsS.selected = false;
        fiveDifferentMealsSiew.backgroundColor = [UIColor whiteColor];
        fiveDifferentMealsSLabel.textColor = [Utility colorWithHexString:@"E425A0"];
        
        differentDailyS.selected = true;
        differentDailySiew.backgroundColor = [Utility colorWithHexString:@"E425A0"];
        differentDailySLabel.textColor = [UIColor whiteColor];
//        [sameMealEverydayS setImage:[UIImage imageNamed:@"uncheckbox_recip.png"] forState:UIControlStateNormal];
//        [differentMealsS setImage:[UIImage imageNamed:@"uncheckbox_recip.png"] forState:UIControlStateNormal];
//        [fiveDifferentMealsS setImage:[UIImage imageNamed:@"uncheckbox_recip.png"] forState:UIControlStateNormal];
//        [differentDailyS setImage:[UIImage imageNamed:@"checkbox_recip.png"] forState:UIControlStateNormal];
    }
    if (sameMealEverydayS.selected) {
        snackUpdateValue =1;
    }else if(differentMealsS.selected) {
        snackUpdateValue =3;
    }else if(fiveDifferentMealsS.selected) {
        snackUpdateValue =5;
    }else if(differentDailyS.selected) {
        snackUpdateValue =7;
    }
    isSaveDefault=false;
    [self webServiceCall_SaveUserMealVariety];
}
#pragma mark - End

#pragma mark - Private Function
-(void)setSegmentedButton:(int )value{
    if (value >75) {
        noMeasureSegmentedButton.selectedSegmentIndex = 0;
        standard = 100;
        nomeasure = 0;
    }else if (value <=75 && value >50) {
        noMeasureSegmentedButton.selectedSegmentIndex = 1;
        standard = 75;
        nomeasure = 25;
    }else if (value <=50 && value >25) {
        noMeasureSegmentedButton.selectedSegmentIndex = 2;
        standard = 50;
        nomeasure = 50;
    }else if (value <=25 && value >0) {
        noMeasureSegmentedButton.selectedSegmentIndex = 3;
        standard = 25;
        nomeasure = 75;
    }else{
        noMeasureSegmentedButton.selectedSegmentIndex = 4;
        standard = 0;
        nomeasure = 100;
    }
    NSString *str = [@"" stringByAppendingFormat:@"Standard %d",standard];
    str = [str stringByAppendingString:@"% - "];
    str = [str stringByAppendingFormat:@"%d",nomeasure];
    str = [str stringByAppendingString:@"% No Measure"];
    standardMeasureLabel.text = str;
}
-(void)setUpView{
    sameMealEverydayB.selected = false;
    sameMealEverydayBView.backgroundColor = [UIColor whiteColor];
    sameMealEverydayBLabel.textColor = [Utility colorWithHexString:@"E425A0"];
    
    differentMealsB.selected = true;
    differentMealsBView.backgroundColor = [Utility colorWithHexString:@"E425A0"];
    differentMealsBLabel.textColor = [UIColor whiteColor];
    
    differentDailyB.selected = false;
    differentDailyBiew.backgroundColor = [UIColor whiteColor];
    differentDailyBLabel.textColor = [Utility colorWithHexString:@"E425A0"];
    
    //Lunch
    
    sameMealEverydayL.selected = false;
    sameMealEverydayLView.backgroundColor = [UIColor whiteColor];
    sameMealEverydaylLabel.textColor = [Utility colorWithHexString:@"E425A0"];
    
    differentMealsL.selected = false;
    differentMealsLView.backgroundColor = [UIColor whiteColor];
    differentMealslLabel.textColor = [Utility colorWithHexString:@"E425A0"];
    
    fiveDifferentMealsL.selected = true;
    fiveDifferentMealsLView.backgroundColor = [Utility colorWithHexString:@"E425A0"];
    fiveDifferentMealslLabel.textColor = [UIColor whiteColor];
    
    
    differentDailyL.selected = false;
    differentDailyLiew.backgroundColor = [UIColor whiteColor];
    differentDailylLabel.textColor = [Utility colorWithHexString:@"E425A0"];
    
    //
    
    //Dinner
    sameMealEverydayD.selected = false;
    sameMealEverydayDView.backgroundColor = [UIColor whiteColor];
    sameMealEverydayDLabel.textColor = [Utility colorWithHexString:@"E425A0"];
    
    differentMealsD.selected = false;
    differentMealsDView.backgroundColor = [UIColor whiteColor];
    differentMealsDLabel.textColor = [Utility colorWithHexString:@"E425A0"];
    
    fiveDifferentMealsD.selected = true;
    fiveDifferentMealsDiew.backgroundColor = [Utility colorWithHexString:@"E425A0"];
    fiveDifferentMealsDLabel.textColor = [UIColor whiteColor];
    
    differentDailyD.selected = false;
    differentDailyDiew.backgroundColor = [UIColor whiteColor];
    differentDailyDLabel.textColor = [Utility colorWithHexString:@"E425A0"];
    //
    
    //Snack
    sameMealEverydayS.selected = false;
    sameMealEverydaySView.backgroundColor = [UIColor whiteColor];
    sameMealEverydaySLabel.textColor = [Utility colorWithHexString:@"E425A0"];
    
    differentMealsS.selected = false;
    differentMealsSView.backgroundColor = [UIColor whiteColor];
    differentMealsSLabel.textColor = [Utility colorWithHexString:@"E425A0"];
    
    fiveDifferentMealsS.selected = true;
    fiveDifferentMealsSiew.backgroundColor = [Utility colorWithHexString:@"E425A0"];
    fiveDifferentMealsSLabel.textColor = [UIColor whiteColor];
    
    differentDailyS.selected = false;
    differentDailySiew.backgroundColor = [UIColor whiteColor];
    differentDailySLabel.textColor = [Utility colorWithHexString:@"E425A0"];
    //
    /*
    [sameMealEverydayB setImage:[UIImage imageNamed:@"uncheckbox_recip.png"] forState:UIControlStateNormal];
    [differentMealsB setImage:[UIImage imageNamed:@"checkbox_recip.png"] forState:UIControlStateNormal];
    [differentDailyB setImage:[UIImage imageNamed:@"uncheckbox_recip.png"] forState:UIControlStateNormal];
    
    [sameMealEverydayL setImage:[UIImage imageNamed:@"uncheckbox_recip.png"] forState:UIControlStateNormal];
    [differentMealsL setImage:[UIImage imageNamed:@"checkbox_recip.png"] forState:UIControlStateNormal];
    [fiveDifferentMealsL setImage:[UIImage imageNamed:@"uncheckbox_recip.png"] forState:UIControlStateNormal];
    [differentDailyL setImage:[UIImage imageNamed:@"uncheckbox_recip.png"] forState:UIControlStateNormal];
    
    
    [sameMealEverydayD setImage:[UIImage imageNamed:@"uncheckbox_recip.png"] forState:UIControlStateNormal];
    [differentMealsD setImage:[UIImage imageNamed:@"checkbox_recip.png"] forState:UIControlStateNormal];
    [fiveDifferentMealsD setImage:[UIImage imageNamed:@"uncheckbox_recip.png"] forState:UIControlStateNormal];
    [differentDailyD setImage:[UIImage imageNamed:@"uncheckbox_recip.png"] forState:UIControlStateNormal];
    
    
    [sameMealEverydayS setImage:[UIImage imageNamed:@"uncheckbox_recip.png"] forState:UIControlStateNormal];
    [differentMealsS setImage:[UIImage imageNamed:@"checkbox_recip.png"] forState:UIControlStateNormal];
    [fiveDifferentMealsS setImage:[UIImage imageNamed:@"uncheckbox_recip.png"] forState:UIControlStateNormal];
    [differentDailyS setImage:[UIImage imageNamed:@"uncheckbox_recip.png"] forState:UIControlStateNormal];
     */
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
                                                                         stepnumber=[[responseDict objectForKey:@"StepNumber"]intValue];
                                                                         if (stepnumber==0) {
                                                                             //if([[self.navigationController.viewControllers firstObject] isKindOfClass:[TrailHomeViewController class]] || [defaults boolForKey:@"IsNonSubscribedUser"]){
                                                                             if(![Utility isSubscribedUser]){
                                                                                 backToNutritionSettings.hidden=true;
                                                                                 backToNutritionSettingsButtonHeightConstant.constant = 0;
                                                                                 noMeasureContainerHeightConstraint.constant = 0;
                                                                                 mealCategoryHeightConstraint.constant = 0;
                                                                                 descriptionTextView.text = @"";
                                                                                 standardMeasureLabel.hidden = true;
                                                                             }else{
                                                                                 backToNutritionSettings.hidden=false;
                                                                                 backToNutritionSettingsButtonHeightConstant.constant = 40;
                                                                                 noMeasureContainerHeightConstraint.constant = 83;
                                                                                 mealCategoryHeightConstraint.constant = 40;
                                                                                 standardMeasureLabel.hidden = false;
                                                                                 [self mealcategory];
                                                                             }
                                                                             
                                                                         }else{
                                                                             backToNutritionSettings.hidden=true;
                                                                             backToNutritionSettingsButtonHeightConstant.constant = 0;
                                                                             noMeasureContainerHeightConstraint.constant = 0;
                                                                             mealCategoryHeightConstraint.constant = 0;
                                                                             descriptionTextView.text = @"";
                                                                             standardMeasureLabel.hidden = true;

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

-(void)webSerViceCall_UpdateNutrationStep:(BOOL)isSave{
    if (stepnumber != 0) {// < stepNumber) {
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
        
        [mainDict setObject:[defaults objectForKey:@"UserID"] forKey:@"UserID"];
        [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        
        [mainDict setObject:[NSNumber numberWithInteger:5] forKey:@"StepNumber"];
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
                                                                 if (self->contentView) {
                                                                     [self->contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"]boolValue]) {
                                                                         if (isSave) {
                                                                             MealPlanViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MealPlanView"];
                                                                             BOOL animated = YES;
                                                                             if (![[defaults objectForKey:@"IsAllStepComplete"]boolValue] && ![[defaults objectForKey:@"IsRedoDone"]boolValue]) {
                                                                                 animated = NO;
                                                                             }
                                                                             [self.navigationController pushViewController:controller animated:animated];
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
-(void)webServiceCall_SaveUserMealVariety{ //add_16/8/17
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
        NSMutableDictionary *modelDict = [[NSMutableDictionary alloc]init];
        NSMutableDictionary *MealVarietyDict = [[NSMutableDictionary alloc]init];
        
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        
        [MealVarietyDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserID"];
        [MealVarietyDict setObject:[NSNumber numberWithInt:breakfastUpadteValue] forKey:@"Breaky"];
        [MealVarietyDict setObject:[NSNumber numberWithInt:lunchUpdateValue] forKey:@"Lunch"];
        [MealVarietyDict setObject:[NSNumber numberWithInt:dinnerUpdateValue] forKey:@"Dinner"];
        [MealVarietyDict setObject:[NSNumber numberWithInt:snackUpdateValue] forKey:@"Snacks"];
        
        if (![Utility isEmptyCheck:MealClassifiedUserMap]) {
            if (![Utility isEmptyCheck:[MealClassifiedUserMap objectForKey:@"Id"]]) {
                [modelDict setObject:[MealClassifiedUserMap objectForKey:@"Id"] forKey:@"Id"];
            }
            if (![Utility isEmptyCheck:[MealClassifiedUserMap objectForKey:@"IsAll"]]) {
                [modelDict setObject:[MealClassifiedUserMap objectForKey:@"IsAll"] forKey:@"IsAll"];
            }
            if (![Utility isEmptyCheck:[MealClassifiedUserMap objectForKey:@"IsQuickNEasy"]]) {
                [modelDict setObject:[MealClassifiedUserMap objectForKey:@"IsQuickNEasy"] forKey:@"IsQuickNEasy"];
            }
            if(![Utility isEmptyCheck:[MealClassifiedUserMap objectForKey:@"UserID"]]){
                [modelDict setObject:[MealClassifiedUserMap objectForKey:@"UserID"] forKey:@"UserID"];
            }
        }
        [modelDict setObject:[NSNumber numberWithInt:nomeasure] forKey:@"NoMeasure"];
        [modelDict setObject:[NSNumber numberWithInt:standard] forKey:@"StandardMeal"];
        // [modelDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserID"];
        
        [mainDict setObject:modelDict forKey:@"MealClassification"];
        [mainDict setObject:MealVarietyDict forKey:@"MealVariety"];
        
        isSaveDefault =false;
        //        [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"SaveUserMealVarietyWithMealClassification" append:@""forAction:@"POST"];
        
        //NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"SaveUserMealVariety" append:@""forAction:@"POST"];
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
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"]boolValue]) {
                                                                         if (!(self->stepnumber == 0)) {
                                                                             if ((![[defaults objectForKey:@"IsAllStepComplete"]boolValue] && ![[defaults objectForKey:@"IsRedoDone"]boolValue])) {
                                                                                 [self webSerViceCall_UpdateNutrationStep:true];
                                                                             }else{
                                                                                 [self webSerViceCall_UpdateNutrationStep:false];
                                                                             }
                                                                         }
                                                                         if (self->stepnumber == 0)
                                                                             [Utility msg:@"Saved Successful! Meals from yesterday and older will not be updated with the new settings" title:@"Success!" controller:self haveToPop:NO];
                                                                         if (self->isDefault){
                                                                             if (!(self->stepnumber == 0)) {
                                                                                 [self webSerViceCall_UpdateNutrationStep:true];
                                                                             }else{
                                                                                 MealPlanViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MealPlanView"];
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

-(void)webServiceCall_GetUserMealClassifiedUserMap{ //add_16/8/17
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
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetUserMealClassifiedUserMap" append:@""forAction:@"POST"];
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
                                                                         MealClassifiedUserMap = [[responseDict objectForKey:@"MealClassifiedUserMapObj"]mutableCopy];
                                                                         if (![Utility isEmptyCheck:[MealClassifiedUserMap objectForKey:@"StandardMeal"]]) {
                                                                             [self setSegmentedButton:[[MealClassifiedUserMap objectForKey:@"StandardMeal"]intValue]];
                                                                         }else{
                                                                             [self setSegmentedButton:75];
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

-(void)webServiceCall_GetUserMealVariety{
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            apiCount++;
            if (contentView) {
                [contentView removeFromSuperview];
            }
            contentView = [Utility activityIndicatorView:self];
        });
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSMutableURLRequest *request = [Utility getRequest:@"" api:@"GetUserMealVariety" append:[@"" stringByAppendingFormat:@"%@", [defaults objectForKey:@"ABBBCOnlineUserId"]] forAction:@"GET"];
        
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(),^ {
                                                                 apiCount--;
                                                                 if (contentView && apiCount == 0) {
                                                                     [contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDictionary] && [[responseDictionary objectForKey:@"Success"] boolValue]) {
                                                                         NSDictionary *mealVariety =[responseDictionary objectForKey:@"obj"];
                                                                         
                                                                         if (![Utility isEmptyCheck:mealVariety]) {
                                                                             isSaveDefault=false;
                                                                             int breakyNumber = [[mealVariety objectForKey:@"Breaky"]intValue];
                                                                             
                                                                             if (breakyNumber) {
                                                                                 breakfastUpadteValue=breakyNumber;

                                                                                 NSLog(@"breaky-%@",[mealBreakfastType objectForKey:[@"" stringByAppendingFormat:@"%d",breakyNumber]]);
                                                                                 
                                                                                 NSString *mealvalue = [mealBreakfastType objectForKey:[@"" stringByAppendingFormat:@"%d",breakyNumber]];
                                                                                 if ([mealvalue isEqualToString:@"Same_Everyday"]) {
                                                                                     sameMealEverydayB.selected = true;
                                                                                     sameMealEverydayBView.backgroundColor = [Utility colorWithHexString:@"E425A0"];
                                                                                     sameMealEverydayBLabel.textColor = [UIColor whiteColor];
                                                                                     
                                                                                     differentMealsB.selected = false;
                                                                                     differentMealsBView.backgroundColor = [UIColor whiteColor];
                                                                                     differentMealsBLabel.textColor = [Utility colorWithHexString:@"E425A0"];
                                                                                     
                                                                                     differentDailyB.selected = false;
                                                                                     differentDailyBiew.backgroundColor = [UIColor whiteColor];
                                                                                     differentDailyBLabel.textColor = [Utility colorWithHexString:@"E425A0"];
                                                                                     
//                                                                                     [sameMealEverydayB setImage:[UIImage imageNamed:@"checkbox_recip.png"] forState:UIControlStateNormal];
//                                                                                     [differentMealsB setImage:[UIImage imageNamed:@"uncheckbox_recip.png"] forState:UIControlStateNormal];
//                                                                                     [differentDailyB setImage:[UIImage imageNamed:@"uncheckbox_recip.png"] forState:UIControlStateNormal];

                                                                                 }else  if ([mealvalue isEqualToString:@"Different2_3"]) {
                                                                                     
                                                                                     sameMealEverydayB.selected = false;
                                                                                     sameMealEverydayBView.backgroundColor = [UIColor whiteColor];
                                                                                     sameMealEverydayBLabel.textColor = [Utility colorWithHexString:@"E425A0"];
                                                                                     
                                                                                     differentMealsB.selected = true;
                                                                                     differentMealsBView.backgroundColor = [Utility colorWithHexString:@"E425A0"];
                                                                                     differentMealsBLabel.textColor = [UIColor whiteColor];
                                                                                     
                                                                                     differentDailyB.selected = false;
                                                                                     differentDailyBiew.backgroundColor = [UIColor whiteColor];
                                                                                     differentDailyBLabel.textColor = [Utility colorWithHexString:@"E425A0"];
                                                                                     
//                                                                                     [sameMealEverydayB setImage:[UIImage imageNamed:@"uncheckbox_recip.png"] forState:UIControlStateNormal];
//                                                                                     [differentMealsB setImage:[UIImage imageNamed:@"checkbox_recip.png"] forState:UIControlStateNormal];
//                                                                                     [differentDailyB setImage:[UIImage imageNamed:@"uncheckbox_recip.png"] forState:UIControlStateNormal];
                                                                                     
                                                                                 }else  if ([mealvalue isEqualToString:@"Different_Daily"]) {
                                                                                     sameMealEverydayB.selected = false;
                                                                                     sameMealEverydayBView.backgroundColor = [UIColor whiteColor];
                                                                                     sameMealEverydayBLabel.textColor = [Utility colorWithHexString:@"E425A0"];
                                                                                     
                                                                                     differentMealsB.selected = false;
                                                                                     differentMealsBView.backgroundColor = [UIColor whiteColor];
                                                                                     differentMealsBLabel.textColor = [Utility colorWithHexString:@"E425A0"];
                                                                                     
                                                                                     differentDailyB.selected = true;
                                                                                     differentDailyBiew.backgroundColor = [Utility colorWithHexString:@"E425A0"];
                                                                                     differentDailyBLabel.textColor = [UIColor whiteColor];
                                                                                     
//                                                                                     [sameMealEverydayB setImage:[UIImage imageNamed:@"uncheckbox_recip.png"] forState:UIControlStateNormal];
//                                                                                     [differentMealsB setImage:[UIImage imageNamed:@"uncheckbox_recip.png"] forState:UIControlStateNormal];
//                                                                                     [differentDailyB setImage:[UIImage imageNamed:@"checkbox_recip.png"] forState:UIControlStateNormal];
//
                                                                                 }
                                                                             }else{
                                                                                 breakfastUpadteValue=1;
                                                                                 sameMealEverydayB.selected = true;
                                                                                 sameMealEverydayBView.backgroundColor = [Utility colorWithHexString:@"E425A0"];
                                                                                 sameMealEverydayBLabel.textColor = [UIColor whiteColor];
                                                                                 
                                                                                 differentMealsB.selected = false;
                                                                                 differentMealsBView.backgroundColor = [UIColor whiteColor];
                                                                                 differentMealsBLabel.textColor = [Utility colorWithHexString:@"E425A0"];
                                                                                 
                                                                                 differentDailyB.selected = false;
                                                                                 differentDailyBiew.backgroundColor = [UIColor whiteColor];
                                                                                 differentDailyBLabel.textColor = [Utility colorWithHexString:@"E425A0"];
                                                                             }
                                                                             int dinnerNumber = [[mealVariety objectForKey:@"Dinner"]intValue];
                                                                             
                                                                             if (dinnerNumber) {
                                                                                   dinnerUpdateValue=dinnerNumber;
                                                                                 NSLog(@"dinner-%@",[mealDinnerLunchSnackType objectForKey:[@"" stringByAppendingFormat:@"%d",dinnerNumber]]);
                                                                                 
                                                                                 NSString *mealvalue = [mealDinnerLunchSnackType objectForKey:[@"" stringByAppendingFormat:@"%d",dinnerNumber]];
                                                                                 if ([mealvalue isEqualToString:@"Same_Everyday"]) {
                                                                                     
                                                                                     sameMealEverydayD.selected = true;
                                                                                     sameMealEverydayDView.backgroundColor = [Utility colorWithHexString:@"E425A0"];
                                                                                     sameMealEverydayDLabel.textColor = [UIColor whiteColor];
                                                                                     
                                                                                     differentMealsD.selected = false;
                                                                                     differentMealsDView.backgroundColor = [UIColor whiteColor];
                                                                                     differentMealsDLabel.textColor = [Utility colorWithHexString:@"E425A0"];
                                                                                     
                                                                                     fiveDifferentMealsD.selected = false;
                                                                                     fiveDifferentMealsDiew.backgroundColor = [UIColor whiteColor];
                                                                                     fiveDifferentMealsDLabel.textColor = [Utility colorWithHexString:@"E425A0"];
                                                                                     
                                                                                     differentDailyD.selected = false;
                                                                                     differentDailyDiew.backgroundColor = [UIColor whiteColor];
                                                                                     differentDailyDLabel.textColor = [Utility colorWithHexString:@"E425A0"];
//                                                                                     [sameMealEverydayD setImage:[UIImage imageNamed:@"checkbox_recip.png"] forState:UIControlStateNormal];
//                                                                                     [differentMealsD setImage:[UIImage imageNamed:@"uncheckbox_recip.png"] forState:UIControlStateNormal];
//                                                                                     [fiveDifferentMealsD setImage:[UIImage imageNamed:@"uncheckbox_recip.png"] forState:UIControlStateNormal];
//                                                                                     [differentDailyD setImage:[UIImage imageNamed:@"uncheckbox_recip.png"] forState:UIControlStateNormal];
                                                                                     
                                                                                 }else  if ([mealvalue isEqualToString:@"Different2_3"]) {
                                                                                     
                                                                                     sameMealEverydayD.selected = false;
                                                                                     sameMealEverydayDView.backgroundColor = [UIColor whiteColor];
                                                                                     sameMealEverydayDLabel.textColor = [Utility colorWithHexString:@"E425A0"];
                                                                                     
                                                                                     differentMealsD.selected = true;
                                                                                     differentMealsDView.backgroundColor = [Utility colorWithHexString:@"E425A0"];
                                                                                     differentMealsDLabel.textColor = [UIColor whiteColor];
                                                                                     
                                                                                     fiveDifferentMealsD.selected = false;
                                                                                     fiveDifferentMealsDiew.backgroundColor = [UIColor whiteColor];
                                                                                     fiveDifferentMealsDLabel.textColor = [Utility colorWithHexString:@"E425A0"];
                                                                                     
                                                                                     differentDailyD.selected = false;
                                                                                     differentDailyDiew.backgroundColor = [UIColor whiteColor];
                                                                                     differentDailyDLabel.textColor = [Utility colorWithHexString:@"E425A0"];
//                                                                                     [sameMealEverydayD setImage:[UIImage imageNamed:@"uncheckbox_recip.png"] forState:UIControlStateNormal];
//                                                                                     [differentMealsD setImage:[UIImage imageNamed:@"checkbox_recip.png"] forState:UIControlStateNormal];
//                                                                                     [fiveDifferentMealsD setImage:[UIImage imageNamed:@"uncheckbox_recip.png"] forState:UIControlStateNormal];
//                                                                                     [differentDailyD setImage:[UIImage imageNamed:@"uncheckbox_recip.png"] forState:UIControlStateNormal];
//
                                                                                     
                                                                                 }else  if ([mealvalue isEqualToString:@"Different5"]) {
                                                                                     sameMealEverydayD.selected = false;
                                                                                     sameMealEverydayDView.backgroundColor = [UIColor whiteColor];
                                                                                     sameMealEverydayDLabel.textColor = [Utility colorWithHexString:@"E425A0"];
                                                                                     
                                                                                     differentMealsD.selected = false;
                                                                                     differentMealsDView.backgroundColor = [UIColor whiteColor];
                                                                                     differentMealsDLabel.textColor = [Utility colorWithHexString:@"E425A0"];
                                                                                     
                                                                                     fiveDifferentMealsD.selected = true;
                                                                                     fiveDifferentMealsDiew.backgroundColor = [Utility colorWithHexString:@"E425A0"];
                                                                                     fiveDifferentMealsDLabel.textColor = [UIColor whiteColor];
                                                                                     
                                                                                     differentDailyD.selected = false;
                                                                                     differentDailyDiew.backgroundColor = [UIColor whiteColor];
                                                                                     differentDailyDLabel.textColor = [Utility colorWithHexString:@"E425A0"];
//                                                                                     [sameMealEverydayD setImage:[UIImage imageNamed:@"uncheckbox_recip.png"] forState:UIControlStateNormal];
//                                                                                     [differentMealsD setImage:[UIImage imageNamed:@"uncheckbox_recip.png"] forState:UIControlStateNormal];
//                                                                                     [fiveDifferentMealsD setImage:[UIImage imageNamed:@"checkbox_recip.png"] forState:UIControlStateNormal];
//                                                                                     [differentDailyD setImage:[UIImage imageNamed:@"uncheckbox_recip.png"] forState:UIControlStateNormal];
                                                                                     
                                                                                 }else  if ([mealvalue isEqualToString:@"Different_Daily"]) {
                                                                                     sameMealEverydayD.selected = false;
                                                                                     sameMealEverydayDView.backgroundColor = [UIColor whiteColor];
                                                                                     sameMealEverydayDLabel.textColor = [Utility colorWithHexString:@"E425A0"];
                                                                                     
                                                                                     differentMealsD.selected = false;
                                                                                     differentMealsDView.backgroundColor = [UIColor whiteColor];
                                                                                     differentMealsDLabel.textColor = [Utility colorWithHexString:@"E425A0"];
                                                                                     
                                                                                     fiveDifferentMealsD.selected = false;
                                                                                     fiveDifferentMealsDiew.backgroundColor = [UIColor whiteColor];
                                                                                     fiveDifferentMealsDLabel.textColor = [Utility colorWithHexString:@"E425A0"];
                                                                                     
                                                                                     differentDailyD.selected = true;
                                                                                     differentDailyDiew.backgroundColor = [Utility colorWithHexString:@"E425A0"];
                                                                                     differentDailyDLabel.textColor = [UIColor whiteColor];
//                                                                                     [sameMealEverydayD setImage:[UIImage imageNamed:@"uncheckbox_recip.png"] forState:UIControlStateNormal];
//                                                                                     [differentMealsD setImage:[UIImage imageNamed:@"uncheckbox_recip.png"] forState:UIControlStateNormal];
//                                                                                     [fiveDifferentMealsD setImage:[UIImage imageNamed:@"uncheckbox_recip.png"] forState:UIControlStateNormal];
//                                                                                     [differentDailyD setImage:[UIImage imageNamed:@"checkbox_recip.png"] forState:UIControlStateNormal];
                                                                                 }
                                                                             }else{
                                                                                 dinnerUpdateValue=1;
                                                                                 sameMealEverydayD.selected = true;
                                                                                 sameMealEverydayDView.backgroundColor = [Utility colorWithHexString:@"E425A0"];
                                                                                 sameMealEverydayDLabel.textColor = [UIColor whiteColor];
                                                                                 
                                                                                 differentMealsD.selected = false;
                                                                                 differentMealsDView.backgroundColor = [UIColor whiteColor];
                                                                                 differentMealsDLabel.textColor = [Utility colorWithHexString:@"E425A0"];
                                                                                 
                                                                                 fiveDifferentMealsD.selected = false;
                                                                                 fiveDifferentMealsDiew.backgroundColor = [UIColor whiteColor];
                                                                                 fiveDifferentMealsDLabel.textColor = [Utility colorWithHexString:@"E425A0"];
                                                                                 
                                                                                 differentDailyD.selected = false;
                                                                                 differentDailyDiew.backgroundColor = [UIColor whiteColor];
                                                                                 differentDailyDLabel.textColor = [Utility colorWithHexString:@"E425A0"];
//                                                                                 [sameMealEverydayD setImage:[UIImage imageNamed:@"checkbox_recip.png"] forState:UIControlStateNormal];
//                                                                                 [differentMealsD setImage:[UIImage imageNamed:@"uncheckbox_recip.png"] forState:UIControlStateNormal];
//                                                                                 [fiveDifferentMealsD setImage:[UIImage imageNamed:@"uncheckbox_recip.png"] forState:UIControlStateNormal];
//                                                                                 [differentDailyD setImage:[UIImage imageNamed:@"uncheckbox_recip.png"] forState:UIControlStateNormal];
                                                                             }
                                                                             
                                                                             int lunchNumber = [[mealVariety objectForKey:@"Lunch"]intValue];
                                                                             if (lunchNumber) {
                                                                                 lunchUpdateValue=lunchNumber;
                                                                                 NSLog(@"lunch-%@",[mealDinnerLunchSnackType objectForKey:[@"" stringByAppendingFormat:@"%d",lunchNumber]]);
                                                                                 
                                                                                 NSString *mealvalue = [mealDinnerLunchSnackType objectForKey:[@"" stringByAppendingFormat:@"%d",lunchNumber]];
                                                                                 if ([mealvalue isEqualToString:@"Same_Everyday"]) {
                                                                                     sameMealEverydayL.selected = true;
                                                                                     sameMealEverydayLView.backgroundColor = [Utility colorWithHexString:@"E425A0"];
                                                                                     sameMealEverydaylLabel.textColor = [UIColor whiteColor];
                                                                                     
                                                                                     differentMealsL.selected = false;
                                                                                     differentMealsLView.backgroundColor = [UIColor whiteColor];
                                                                                     differentMealslLabel.textColor = [Utility colorWithHexString:@"E425A0"];
                                                                                     
                                                                                     differentDailyL.selected = false;
                                                                                     differentDailyLiew.backgroundColor = [UIColor whiteColor];
                                                                                     differentDailylLabel.textColor = [Utility colorWithHexString:@"E425A0"];
                                                                                     
                                                                                     fiveDifferentMealsL.selected = false;
                                                                                     fiveDifferentMealsLView.backgroundColor = [UIColor whiteColor];
                                                                                     fiveDifferentMealslLabel.textColor = [Utility colorWithHexString:@"E425A0"];
//                                                                                     [sameMealEverydayL setImage:[UIImage imageNamed:@"checkbox_recip.png"] forState:UIControlStateNormal];
//                                                                                     [differentMealsL setImage:[UIImage imageNamed:@"uncheckbox_recip.png"] forState:UIControlStateNormal];
//                                                                                     [fiveDifferentMealsL setImage:[UIImage imageNamed:@"uncheckbox_recip.png"] forState:UIControlStateNormal];
//                                                                                     [differentDailyL setImage:[UIImage imageNamed:@"uncheckbox_recip.png"] forState:UIControlStateNormal];
                                                                                     
                                                                                     
                                                                                 }else  if ([mealvalue isEqualToString:@"Different2_3"]) {
                                                                                     sameMealEverydayL.selected = false;
                                                                                     sameMealEverydayLView.backgroundColor = [UIColor whiteColor];
                                                                                     sameMealEverydaylLabel.textColor = [Utility colorWithHexString:@"E425A0"];
                                                                                     
                                                                                     differentMealsL.selected = true;
                                                                                     differentMealsLView.backgroundColor = [Utility colorWithHexString:@"E425A0"];
                                                                                     differentMealslLabel.textColor = [UIColor whiteColor];
                                                                                     
                                                                                     fiveDifferentMealsL.selected = false;
                                                                                     fiveDifferentMealsLView.backgroundColor = [UIColor whiteColor];
                                                                                     fiveDifferentMealslLabel.textColor = [Utility colorWithHexString:@"E425A0"];
                                                                                     
                                                                                     
                                                                                     differentDailyL.selected = false;
                                                                                     differentDailyLiew.backgroundColor = [UIColor whiteColor];
                                                                                     differentDailylLabel.textColor = [Utility colorWithHexString:@"E425A0"];
//                                                                                     [sameMealEverydayL setImage:[UIImage imageNamed:@"uncheckbox_recip.png"] forState:UIControlStateNormal];
//                                                                                     [differentMealsL setImage:[UIImage imageNamed:@"checkbox_recip.png"] forState:UIControlStateNormal];
//                                                                                     [fiveDifferentMealsL setImage:[UIImage imageNamed:@"uncheckbox_recip.png"] forState:UIControlStateNormal];
//                                                                                     [differentDailyL setImage:[UIImage imageNamed:@"uncheckbox_recip.png"] forState:UIControlStateNormal];
                                                                                     
                                                                                     
                                                                                 }else  if ([mealvalue isEqualToString:@"Different5"]) {
                                                                                     sameMealEverydayL.selected = false;
                                                                                     sameMealEverydayLView.backgroundColor = [UIColor whiteColor];
                                                                                     sameMealEverydaylLabel.textColor = [Utility colorWithHexString:@"E425A0"];
                                                                                     
                                                                                     differentMealsL.selected = false;
                                                                                     differentMealsLView.backgroundColor = [UIColor whiteColor];
                                                                                     differentMealslLabel.textColor = [Utility colorWithHexString:@"E425A0"];
                                                                                     
                                                                                     fiveDifferentMealsL.selected = true;
                                                                                     fiveDifferentMealsLView.backgroundColor = [Utility colorWithHexString:@"E425A0"];
                                                                                     fiveDifferentMealslLabel.textColor = [UIColor whiteColor];
                                                                                     
                                                                                     differentDailyL.selected = false;
                                                                                     differentDailyLiew.backgroundColor = [UIColor whiteColor];
                                                                                     differentDailylLabel.textColor = [Utility colorWithHexString:@"E425A0"];
//                                                                                     [sameMealEverydayL setImage:[UIImage imageNamed:@"uncheckbox_recip.png"] forState:UIControlStateNormal];
//                                                                                     [differentMealsL setImage:[UIImage imageNamed:@"uncheckbox_recip.png"] forState:UIControlStateNormal];
//                                                                                     [fiveDifferentMealsL setImage:[UIImage imageNamed:@"checkbox_recip.png"] forState:UIControlStateNormal];
//                                                                                     [differentDailyL setImage:[UIImage imageNamed:@"uncheckbox_recip.png"] forState:UIControlStateNormal];
                                                                                     
                                                                                 }else  if ([mealvalue isEqualToString:@"Different_Daily"]) {
                                                                                     sameMealEverydayL.selected = false;
                                                                                     sameMealEverydayLView.backgroundColor = [UIColor whiteColor];
                                                                                     sameMealEverydaylLabel.textColor = [Utility colorWithHexString:@"E425A0"];
                                                                                     
                                                                                     differentMealsL.selected = false;
                                                                                     differentMealsLView.backgroundColor = [UIColor whiteColor];
                                                                                     differentMealslLabel.textColor = [Utility colorWithHexString:@"E425A0"];
                                                                                     
                                                                                     fiveDifferentMealsL.selected = false;
                                                                                     fiveDifferentMealsLView.backgroundColor = [UIColor whiteColor];
                                                                                     fiveDifferentMealslLabel.textColor = [Utility colorWithHexString:@"E425A0"];
                                                                                     
                                                                                     differentDailyL.selected = true;
                                                                                     differentDailyLiew.backgroundColor = [Utility colorWithHexString:@"E425A0"];
                                                                                     differentDailylLabel.textColor = [UIColor whiteColor];
//                                                                                     [sameMealEverydayL setImage:[UIImage imageNamed:@"uncheckbox_recip.png"] forState:UIControlStateNormal];
//                                                                                     [differentMealsL setImage:[UIImage imageNamed:@"uncheckbox_recip.png"] forState:UIControlStateNormal];
//                                                                                     [fiveDifferentMealsL setImage:[UIImage imageNamed:@"uncheckbox_recip.png"] forState:UIControlStateNormal];
//                                                                                     [differentDailyL setImage:[UIImage imageNamed:@"checkbox_recip.png"] forState:UIControlStateNormal];
                                                                                 }
                                                                             }else{
                                                                                 lunchUpdateValue=1;
                                                                                 sameMealEverydayL.selected = true;
                                                                                 sameMealEverydayLView.backgroundColor = [Utility colorWithHexString:@"E425A0"];
                                                                                 sameMealEverydaylLabel.textColor = [UIColor whiteColor];
                                                                                 
                                                                                 differentMealsL.selected = false;
                                                                                 differentMealsLView.backgroundColor = [UIColor whiteColor];
                                                                                 differentMealslLabel.textColor = [Utility colorWithHexString:@"E425A0"];
                                                                                 
                                                                                 differentDailyL.selected = false;
                                                                                 differentDailyLiew.backgroundColor = [UIColor whiteColor];
                                                                                 differentDailylLabel.textColor = [Utility colorWithHexString:@"E425A0"];
                                                                                 
                                                                                 fiveDifferentMealsL.selected = false;
                                                                                 fiveDifferentMealsLView.backgroundColor = [UIColor whiteColor];
                                                                                 fiveDifferentMealslLabel.textColor = [Utility colorWithHexString:@"E425A0"];
//                                                                                 [sameMealEverydayL setImage:[UIImage imageNamed:@"checkbox_recip.png"] forState:UIControlStateNormal];
//                                                                                 [differentMealsL setImage:[UIImage imageNamed:@"uncheckbox_recip.png"] forState:UIControlStateNormal];
//                                                                                 [fiveDifferentMealsL setImage:[UIImage imageNamed:@"uncheckbox_recip.png"] forState:UIControlStateNormal];
//                                                                                 [differentDailyL setImage:[UIImage imageNamed:@"uncheckbox_recip.png"] forState:UIControlStateNormal];

                                                                             }
                                                                             
                                                                             int snacksNumber = [[mealVariety objectForKey:@"Snacks"]intValue];
                                                                             if (snacksNumber) {
                                                                                 snackUpdateValue=snacksNumber;
                                                                                 NSLog(@"snacks-%@",[mealDinnerLunchSnackType objectForKey:[@"" stringByAppendingFormat:@"%d",snacksNumber]]);
                                                                                 
                                                                                 NSString *mealSnackvalue = [mealDinnerLunchSnackType objectForKey:[@"" stringByAppendingFormat:@"%d",snacksNumber]];
                                                                                 
                                                                                 if ([mealSnackvalue isEqualToString:@"Same_Everyday"]) {
                                                                                     sameMealEverydayS.selected = true;
                                                                                     sameMealEverydaySView.backgroundColor = [Utility colorWithHexString:@"E425A0"];
                                                                                     sameMealEverydaySLabel.textColor = [UIColor whiteColor];
                                                                                     
                                                                                     differentMealsS.selected = false;
                                                                                     differentMealsSView.backgroundColor = [UIColor whiteColor];
                                                                                     differentMealsSLabel.textColor = [Utility colorWithHexString:@"E425A0"];
                                                                                     
                                                                                     fiveDifferentMealsS.selected = false;
                                                                                     fiveDifferentMealsSiew.backgroundColor = [UIColor whiteColor];
                                                                                     fiveDifferentMealsSLabel.textColor = [Utility colorWithHexString:@"E425A0"];
                                                                                     
                                                                                     differentDailyS.selected = false;
                                                                                     differentDailySiew.backgroundColor = [UIColor whiteColor];
                                                                                     differentDailySLabel.textColor = [Utility colorWithHexString:@"E425A0"];
//                                                                                     [sameMealEverydayS setImage:[UIImage imageNamed:@"checkbox_recip.png"] forState:UIControlStateNormal];
//                                                                                     [differentMealsS setImage:[UIImage imageNamed:@"uncheckbox_recip.png"] forState:UIControlStateNormal];
//                                                                                     [fiveDifferentMealsS setImage:[UIImage imageNamed:@"uncheckbox_recip.png"] forState:UIControlStateNormal];
//                                                                                     [differentDailyS setImage:[UIImage imageNamed:@"uncheckbox_recip.png"] forState:UIControlStateNormal];
                                                                                     
                                                                                 }else  if ([mealSnackvalue isEqualToString:@"Different2_3"]) {
                                                                                     sameMealEverydayS.selected = false;
                                                                                     sameMealEverydaySView.backgroundColor = [UIColor whiteColor];
                                                                                     sameMealEverydaySLabel.textColor = [Utility colorWithHexString:@"E425A0"];
                                                                                     
                                                                                     differentMealsS.selected = true;
                                                                                     differentMealsSView.backgroundColor = [Utility colorWithHexString:@"E425A0"];
                                                                                     differentMealsSLabel.textColor = [UIColor whiteColor];
                                                                                     
                                                                                     fiveDifferentMealsS.selected = false;
                                                                                     fiveDifferentMealsSiew.backgroundColor = [UIColor whiteColor];
                                                                                     fiveDifferentMealsSLabel.textColor = [Utility colorWithHexString:@"E425A0"];
                                                                                     
                                                                                     differentDailyS.selected = false;
                                                                                     differentDailySiew.backgroundColor = [UIColor whiteColor];
                                                                                     differentDailySLabel.textColor = [Utility colorWithHexString:@"E425A0"];
//                                                                                     [sameMealEverydayS setImage:[UIImage imageNamed:@"uncheckbox_recip.png"] forState:UIControlStateNormal];
//                                                                                     [differentMealsS setImage:[UIImage imageNamed:@"checkbox_recip.png"] forState:UIControlStateNormal];
//                                                                                     [fiveDifferentMealsS setImage:[UIImage imageNamed:@"uncheckbox_recip.png"] forState:UIControlStateNormal];
//                                                                                     [differentDailyS setImage:[UIImage imageNamed:@"uncheckbox_recip.png"] forState:UIControlStateNormal];
//
                                                                                     
                                                                                 }else  if ([mealSnackvalue isEqualToString:@"Different5"]) {
                                                                                     sameMealEverydayS.selected = false;
                                                                                     sameMealEverydaySView.backgroundColor = [UIColor whiteColor];
                                                                                     sameMealEverydaySLabel.textColor = [Utility colorWithHexString:@"E425A0"];
                                                                                     
                                                                                     differentMealsS.selected = false;
                                                                                     differentMealsSView.backgroundColor = [UIColor whiteColor];
                                                                                     differentMealsSLabel.textColor = [Utility colorWithHexString:@"E425A0"];
                                                                                     
                                                                                     fiveDifferentMealsS.selected = true;
                                                                                     fiveDifferentMealsSiew.backgroundColor = [Utility colorWithHexString:@"E425A0"];
                                                                                     fiveDifferentMealsSLabel.textColor = [UIColor whiteColor];
                                                                                     
                                                                                     differentDailyS.selected = false;
                                                                                     differentDailySiew.backgroundColor = [UIColor whiteColor];
                                                                                     differentDailySLabel.textColor = [Utility colorWithHexString:@"E425A0"];
//                                                                                     [sameMealEverydayS setImage:[UIImage imageNamed:@"uncheckbox_recip.png"] forState:UIControlStateNormal];
//                                                                                     [differentMealsS setImage:[UIImage imageNamed:@"uncheckbox_recip.png"] forState:UIControlStateNormal];
//                                                                                     [fiveDifferentMealsS setImage:[UIImage imageNamed:@"checkbox_recip.png"] forState:UIControlStateNormal];
//                                                                                     [differentDailyS setImage:[UIImage imageNamed:@"uncheckbox_recip.png"] forState:UIControlStateNormal];
                                                                                     
                                                                                 }else  if ([mealSnackvalue isEqualToString:@"Different_Daily"]) {
                                                                                     sameMealEverydayS.selected = false;
                                                                                     sameMealEverydaySView.backgroundColor = [UIColor whiteColor];
                                                                                     sameMealEverydaySLabel.textColor = [Utility colorWithHexString:@"E425A0"];
                                                                                     
                                                                                     differentMealsS.selected = false;
                                                                                     differentMealsSView.backgroundColor = [UIColor whiteColor];
                                                                                     differentMealsSLabel.textColor = [Utility colorWithHexString:@"E425A0"];
                                                                                     
                                                                                     fiveDifferentMealsS.selected = false;
                                                                                     fiveDifferentMealsSiew.backgroundColor = [UIColor whiteColor];
                                                                                     fiveDifferentMealsSLabel.textColor = [Utility colorWithHexString:@"E425A0"];
                                                                                     
                                                                                     differentDailyS.selected = true;
                                                                                     differentDailySiew.backgroundColor = [Utility colorWithHexString:@"E425A0"];
                                                                                     differentDailySLabel.textColor = [UIColor whiteColor];
//                                                                                     [sameMealEverydayS setImage:[UIImage imageNamed:@"uncheckbox_recip.png"] forState:UIControlStateNormal];
//                                                                                     [differentMealsS setImage:[UIImage imageNamed:@"uncheckbox_recip.png"] forState:UIControlStateNormal];
//                                                                                     [fiveDifferentMealsS setImage:[UIImage imageNamed:@"uncheckbox_recip.png"] forState:UIControlStateNormal];
//                                                                                     [differentDailyS setImage:[UIImage imageNamed:@"checkbox_recip.png"] forState:UIControlStateNormal];
                                                                                 }
                                                                             }else{
                                                                                 snackUpdateValue=1;
                                                                                 sameMealEverydayS.selected = true;
                                                                                 sameMealEverydaySView.backgroundColor = [Utility colorWithHexString:@"E425A0"];
                                                                                 sameMealEverydaySLabel.textColor = [UIColor whiteColor];
                                                                                 
                                                                                 differentMealsS.selected = false;
                                                                                 differentMealsSView.backgroundColor = [UIColor whiteColor];
                                                                                 differentMealsSLabel.textColor = [Utility colorWithHexString:@"E425A0"];
                                                                                 
                                                                                 fiveDifferentMealsS.selected = false;
                                                                                 fiveDifferentMealsSiew.backgroundColor = [UIColor whiteColor];
                                                                                 fiveDifferentMealsSLabel.textColor = [Utility colorWithHexString:@"E425A0"];
                                                                                 
                                                                                 differentDailyS.selected = false;
                                                                                 differentDailySiew.backgroundColor = [UIColor whiteColor];
                                                                                 differentDailySLabel.textColor = [Utility colorWithHexString:@"E425A0"];
//                                                                                 [sameMealEverydayS setImage:[UIImage imageNamed:@"checkbox_recip.png"] forState:UIControlStateNormal];
//                                                                                 [differentMealsS setImage:[UIImage imageNamed:@"uncheckbox_recip.png"] forState:UIControlStateNormal];
//                                                                                 [fiveDifferentMealsS setImage:[UIImage imageNamed:@"uncheckbox_recip.png"] forState:UIControlStateNormal];
//                                                                                 [differentDailyS setImage:[UIImage imageNamed:@"uncheckbox_recip.png"] forState:UIControlStateNormal];
                                                                             }
                                                                         }else{
                                                                             isSaveDefault=true;
                                                                             [self setUpView];
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

-(void)mealcategory{
    NSString *str = @"\u2022    No Measure' meals are extra simple, tasty and clean meals designed so that even the least confident person can cook clean without having to measure, weight or count a thing.\n\n\u2022    With your custom menu plan you get to decide if you would like more 'no measure' meals or more 'standard' meals that are measuring the exact calories and macro's for your goals.\n\n\u2022    If there are not enough 'no measure' meals to fit your preferences, then we will add in 'standard' meals to fit the gaps.\n\n\u2022    Please try both and find what works best for you. Learning how to make clean and healthy meals that you love the taste of, that keep you feeling full and energised and that help you achieve your goals is probably the number one skill you need to develop. Once you nail this, everything else becomes easier.";
    descriptionTextView.text = str;
}

-(void)frquencyViewSetup{
    sameMealEverydayBView.layer.borderColor = [Utility colorWithHexString:@"E425A0"].CGColor;
    sameMealEverydayBView.layer.borderWidth =1;
    differentMealsBView.layer.borderColor = [Utility colorWithHexString:@"E425A0"].CGColor;
    differentMealsBView.layer.borderWidth=1;
    differentDailyBiew.layer.borderColor = [Utility colorWithHexString:@"E425A0"].CGColor;
    differentDailyBiew.layer.borderWidth=1;
    
    sameMealEverydayLView.layer.borderColor = [Utility colorWithHexString:@"E425A0"].CGColor;
    sameMealEverydayLView.layer.borderWidth=1;
    differentMealsLView.layer.borderColor = [Utility colorWithHexString:@"E425A0"].CGColor;
    differentMealsLView.layer.borderWidth=1;
    differentDailyLiew.layer.borderColor = [Utility colorWithHexString:@"E425A0"].CGColor;
    differentDailyLiew.layer.borderWidth=1;
    fiveDifferentMealsLView.layer.borderColor = [Utility colorWithHexString:@"E425A0"].CGColor;
    fiveDifferentMealsLView.layer.borderWidth=1;

    sameMealEverydayDView.layer.borderColor = [Utility colorWithHexString:@"E425A0"].CGColor;
    sameMealEverydayDView.layer.borderWidth=1;
    differentMealsDView.layer.borderColor = [Utility colorWithHexString:@"E425A0"].CGColor;
    differentMealsDView.layer.borderWidth=1;
    differentDailyDiew.layer.borderColor = [Utility colorWithHexString:@"E425A0"].CGColor;
    differentDailyDiew.layer.borderWidth=1;
    fiveDifferentMealsDiew.layer.borderColor = [Utility colorWithHexString:@"E425A0"].CGColor;
    fiveDifferentMealsDiew.layer.borderWidth=1;

    sameMealEverydaySView.layer.borderColor = [Utility colorWithHexString:@"E425A0"].CGColor;
    sameMealEverydaySView.layer.borderWidth=1;

    differentMealsSView.layer.borderColor = [Utility colorWithHexString:@"E425A0"].CGColor;
    differentMealsSView.layer.borderWidth=1;

    differentDailySiew.layer.borderColor = [Utility colorWithHexString:@"E425A0"].CGColor;
    differentDailySiew.layer.borderWidth=1;

    fiveDifferentMealsSiew.layer.borderColor = [Utility colorWithHexString:@"E425A0"].CGColor;
    fiveDifferentMealsSiew.layer.borderWidth=1;
    
}
#pragma mark  -End

#pragma mark  - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self webSerViceCall_SquadNutritionSettingStep];
        [self webServiceCall_GetUserMealVariety];
        [self webServiceCall_GetUserMealClassifiedUserMap];
    });

    if (![[defaults objectForKey:@"IsAllStepComplete"]boolValue] && ![[defaults objectForKey:@"IsRedoDone"]boolValue]) {
         blankView.hidden = false;
          [self setUpView];
         isSaveDefault = true;
         [self nextbuttonPressed:nil];
    }else{
         blankView.hidden = true;
        [self frquencyViewSetup];
    }
    if(![Utility isSubscribedUser]){
        menuButton.hidden = true;
        footerConstant.constant = 0;
    }else{
        menuButton.hidden = false;
        footerConstant.constant = 75;
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    apiCount= 0;
    isSaveDefault=true;
    isDefault =false;
}
#pragma mark - End

#pragma mark - Memoey Warning

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark  -End
@end
