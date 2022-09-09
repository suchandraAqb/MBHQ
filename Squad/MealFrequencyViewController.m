//
//  MealFrequencyViewController.m
//  Squad
//
//  Created by AQB Solutions-Mac Mini 2 on 31/03/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import "MealFrequencyViewController.h"
#import "Utility.h"
#import "MealVarietyViewController.h"
#import "MealFrequencyTableViewCell.h"
#import "DietaryPreferenceViewController.h"
#import "MealVarietyViewController.h"
#import "NutritionSettingHomeViewController.h"
#import "MasterMenuViewController.h"

@interface MealFrequencyViewController ()
{
    UIView *contentView;
    NSDictionary *mealFrequencyDict;
    IBOutlet NSLayoutConstraint *footerConstant;
    IBOutlet UIButton *menuButton;
    IBOutlet UITableView *frequencyTable;
    IBOutlet UIButton *twoMealButton;
    IBOutlet UIButton *threeMealButton;
    IBOutlet UIButton *fourMealButton;
    IBOutlet UIButton *fiveMealButton;
    IBOutlet UIButton *sixMealButton;
    IBOutlet UIButton *sevenMealButton;
    IBOutlet NSLayoutConstraint *frequencyHeightConstant;
    IBOutlet UIButton *backToNutritionSettings;
    IBOutlet NSLayoutConstraint *backToNutritionSettingsButtonHeightConstant;


    IBOutlet UIButton *firstTimeThreeMeals;
    IBOutlet UIButton *firstTimeThreeMealsOneSnack;
    IBOutlet UIButton *firstTimeThreeMealsTwoSnack;
    IBOutlet UIButton *firstTimeSixSizedMeals;
    IBOutlet UIView *mealFirstTimeView;
    IBOutlet UIScrollView *mealFrequencyScrollView;
    
    NSDictionary *mealTypeDict;
    NSString *selectedMeal;
    int SnackCount;
    int mealCount;
    int stepnumber;
    int apiCount;
    BOOL isSetDeafault;
    BOOL isDefault;
    NSDictionary *getRecCommendedDict;
    int SnackCountDefault;//add9
    int mealCountDefault;
    NSInteger selectedIndex;
    
}
@end

@implementation MealFrequencyViewController

#pragma mark  -IBAction

- (IBAction)menuTapped:(id)sender {
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
    [self.slidingViewController resetTopViewAnimated:YES];
}


- (IBAction)previousbuttonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)nextbuttonPressed:(id)sender {
    if (isSetDeafault) {
        [self setUpView];//nss
        SnackCount=SnackCountDefault;//add9
        mealCount=mealCountDefault;
        int totalmeal = SnackCount+mealCount;
        if (totalmeal == 2) {
            selectedMeal = @"2meal";
            [twoMealButton setBackgroundColor:[Utility colorWithHexString:@"E425A0"]];
        }else if (totalmeal == 3){
            selectedMeal = @"3meal";
            [threeMealButton setBackgroundColor:[Utility colorWithHexString:@"E425A0"]];
        }else if (totalmeal == 4){
            selectedMeal = @"4meal";
            [fourMealButton setBackgroundColor:[Utility colorWithHexString:@"E425A0"]];
        }else if (totalmeal == 5){
            selectedMeal = @"5meal";
            [fiveMealButton setBackgroundColor:[Utility colorWithHexString:@"E425A0"]];
        }else if (totalmeal == 6){
            selectedMeal = @"6meal";
            [sixMealButton setBackgroundColor:[Utility colorWithHexString:@"E425A0"]];
        }else if (totalmeal == 7){
            selectedMeal = @"7meal";
            [sevenMealButton setBackgroundColor:[Utility colorWithHexString:@"E425A0"]];
        }
        
        isDefault =true;//nss
        [self webServiveCall_SaveUserMealFrequency:mealCount with:SnackCount with:totalmeal];

    }else{
        if (!(stepnumber == 0)) {
            [self webSerViceCall_UpdateNutrationStep:true];
        }else{
            MealVarietyViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MealVarietyView"];
            [self.navigationController pushViewController:controller animated:YES];
        }
    }
   
    
}
- (IBAction)logoTapped:(id)sender {
    [self.navigationController  popToRootViewControllerAnimated:YES];
}
- (IBAction)twoMealButtonPressed:(id)sender {
    if(twoMealButton.isSelected) return;
    
    [twoMealButton setBackgroundColor:[Utility colorWithHexString:@"E425A0"]];
    [threeMealButton setBackgroundColor:[UIColor whiteColor]];
    [fourMealButton setBackgroundColor:[UIColor whiteColor]];
    [fiveMealButton setBackgroundColor:[UIColor whiteColor]];
    [sixMealButton setBackgroundColor:[UIColor whiteColor]];
    [sevenMealButton setBackgroundColor:[UIColor whiteColor]];
    
    twoMealButton.selected =true;
    threeMealButton.selected=false;
    fourMealButton.selected=false;
    fiveMealButton.selected=false;
    sixMealButton.selected=false;
    sevenMealButton.selected=false;
    
    isSetDeafault=false;
    selectedMeal =@"2meal";
    SnackCount=0;
    mealCount=2;
    [frequencyTable reloadData];
    [self webServiveCall_SaveUserMealFrequency:mealCount with:SnackCount with:2];
    
}

- (IBAction)threeMealButtonPressed:(id)sender {
    if (![[defaults objectForKey:@"IsAllStepComplete"]boolValue] && ![[defaults objectForKey:@"IsRedoDone"]boolValue]) {
        if(firstTimeThreeMeals.isSelected) return;
        firstTimeThreeMeals.selected = true;
        firstTimeThreeMeals.backgroundColor = [Utility colorWithHexString:@"E425A0"];
        firstTimeThreeMealsOneSnack.selected = false;
        firstTimeThreeMealsOneSnack.backgroundColor =[UIColor whiteColor];
        firstTimeThreeMealsTwoSnack.selected = false;
        firstTimeThreeMealsTwoSnack.backgroundColor = [UIColor whiteColor];
        firstTimeSixSizedMeals.selected = false;
        firstTimeSixSizedMeals.backgroundColor = [UIColor whiteColor];
    }else{
        if(threeMealButton.isSelected) return;
        [threeMealButton setBackgroundColor:[Utility colorWithHexString:@"E425A0"]];
        [twoMealButton setBackgroundColor:[UIColor whiteColor]];
        [fourMealButton setBackgroundColor:[UIColor whiteColor]];
        [fiveMealButton setBackgroundColor:[UIColor whiteColor]];
        [sixMealButton setBackgroundColor:[UIColor whiteColor]];
        [sevenMealButton setBackgroundColor:[UIColor whiteColor]];
        
        threeMealButton.selected = true;
        twoMealButton.selected=false;
        fourMealButton.selected=false;
        fiveMealButton.selected=false;
        sixMealButton.selected=false;
        sevenMealButton.selected=false;
    }
    isSetDeafault=false;
    selectedMeal =@"3meal";
    SnackCount=0;
    mealCount=3;
    [frequencyTable reloadData];
    [self webServiveCall_SaveUserMealFrequency:mealCount with:SnackCount with:3];
}
- (IBAction)fourMealButtonPressed:(id)sender {
    if (![[defaults objectForKey:@"IsAllStepComplete"]boolValue] && ![[defaults objectForKey:@"IsRedoDone"]boolValue]) {
        if(firstTimeThreeMealsOneSnack.isSelected) return;
        firstTimeThreeMeals.selected = false;
        firstTimeThreeMeals.backgroundColor = [UIColor whiteColor];
        firstTimeThreeMealsOneSnack.selected = true;
        firstTimeThreeMealsOneSnack.backgroundColor =[Utility colorWithHexString:@"E425A0"];
        firstTimeThreeMealsTwoSnack.selected = false;
        firstTimeThreeMealsTwoSnack.backgroundColor = [UIColor whiteColor];
        firstTimeSixSizedMeals.selected = false;
        firstTimeSixSizedMeals.backgroundColor = [UIColor whiteColor];
    }else{
        if(fourMealButton.isSelected) return;
        [fourMealButton setBackgroundColor:[Utility colorWithHexString:@"E425A0"]];
        [twoMealButton setBackgroundColor:[UIColor whiteColor]];
        [threeMealButton setBackgroundColor:[UIColor whiteColor]];
        [fiveMealButton setBackgroundColor:[UIColor whiteColor]];
        [sixMealButton setBackgroundColor:[UIColor whiteColor]];
        [sevenMealButton setBackgroundColor:[UIColor whiteColor]];
        
        fourMealButton.selected =true;
        twoMealButton.selected=false;
        threeMealButton.selected=false;
        fiveMealButton.selected=false;
        sixMealButton.selected=false;
        sevenMealButton.selected=false;
    }
    isSetDeafault=false;
    selectedMeal =@"4meal";
    SnackCount=1;
    mealCount=3;
    [frequencyTable reloadData];
    [self webServiveCall_SaveUserMealFrequency:mealCount with:SnackCount with:4];
}
- (IBAction)fiveMealButtonPressed:(id)sender {
   
    if (![[defaults objectForKey:@"IsAllStepComplete"]boolValue] && ![[defaults objectForKey:@"IsRedoDone"]boolValue]) {
        if(firstTimeThreeMealsTwoSnack.isSelected) return;
        firstTimeThreeMeals.selected = false;
        firstTimeThreeMeals.backgroundColor = [UIColor whiteColor];
        firstTimeThreeMealsOneSnack.selected = false;
        firstTimeThreeMealsOneSnack.backgroundColor =[UIColor whiteColor];
        firstTimeThreeMealsTwoSnack.selected = true;
        firstTimeThreeMealsTwoSnack.backgroundColor = [Utility colorWithHexString:@"E425A0"];
        firstTimeSixSizedMeals.selected = false;
        firstTimeSixSizedMeals.backgroundColor = [UIColor whiteColor];
    }else{
        if(fiveMealButton.isSelected) return;
        [fiveMealButton setBackgroundColor:[Utility colorWithHexString:@"E425A0"]];
        [twoMealButton setBackgroundColor:[UIColor whiteColor]];
        [threeMealButton setBackgroundColor:[UIColor whiteColor]];
        [fourMealButton setBackgroundColor:[UIColor whiteColor]];
        [sixMealButton setBackgroundColor:[UIColor whiteColor]];
        [sevenMealButton setBackgroundColor:[UIColor whiteColor]];
        fiveMealButton.selected = true;
        twoMealButton.selected=false;
        threeMealButton.selected=false;
        fourMealButton.selected=false;
        sixMealButton.selected=false;
        sevenMealButton.selected=false;
    }
    
    isSetDeafault=false;
    selectedMeal =@"5meal";
    SnackCount=2;
    mealCount=3;
    [frequencyTable reloadData];
    [self webServiveCall_SaveUserMealFrequency:mealCount with:SnackCount with:5];
}
- (IBAction)sixMealButtonPressed:(id)sender {
    if (![[defaults objectForKey:@"IsAllStepComplete"]boolValue] && ![[defaults objectForKey:@"IsRedoDone"]boolValue]) {
        if(firstTimeSixSizedMeals.isSelected) return;
        firstTimeThreeMeals.selected = false;
        firstTimeThreeMeals.backgroundColor = [UIColor whiteColor];
        firstTimeThreeMealsOneSnack.selected = false;
        firstTimeThreeMealsOneSnack.backgroundColor =[UIColor whiteColor];
        firstTimeThreeMealsTwoSnack.selected = false;
        firstTimeThreeMealsTwoSnack.backgroundColor = [UIColor whiteColor];
        firstTimeSixSizedMeals.selected = true;
        firstTimeSixSizedMeals.backgroundColor = [Utility colorWithHexString:@"E425A0"];
    }else{
        if(sixMealButton.isSelected) return;
        [sixMealButton setBackgroundColor:[Utility colorWithHexString:@"E425A0"]];
        [twoMealButton setBackgroundColor:[UIColor whiteColor]];
        [threeMealButton setBackgroundColor:[UIColor whiteColor]];
        [fourMealButton setBackgroundColor:[UIColor whiteColor]];
        [fiveMealButton setBackgroundColor:[UIColor whiteColor]];
        [sevenMealButton setBackgroundColor:[UIColor whiteColor]];
        
        sixMealButton.selected = true;
        twoMealButton.selected=false;
        threeMealButton.selected=false;
        fourMealButton.selected=false;
        fiveMealButton.selected=false;
        sevenMealButton.selected=false;
    }
    isSetDeafault=false;
    selectedMeal =@"6meal";
    SnackCount=0;
    mealCount=6;
    [frequencyTable reloadData];
    [self webServiveCall_SaveUserMealFrequency:mealCount with:SnackCount with:6];
}
- (IBAction)sevenMealButtonPressed:(id)sender {
    if(sevenMealButton.isSelected) return;
    [sevenMealButton setBackgroundColor:[Utility colorWithHexString:@"E425A0"]];
    
    [twoMealButton setBackgroundColor:[UIColor whiteColor]];
    [threeMealButton setBackgroundColor:[UIColor whiteColor]];
    [fourMealButton setBackgroundColor:[UIColor whiteColor]];
    [fiveMealButton setBackgroundColor:[UIColor whiteColor]];
    [sixMealButton setBackgroundColor:[UIColor whiteColor]];
    sevenMealButton.selected = true;
    twoMealButton.selected=false;
    threeMealButton.selected=false;
    fourMealButton.selected=false;
    fiveMealButton.selected=false;
    sixMealButton.selected=false;

    isSetDeafault=false;
    selectedMeal =@"7meal";
    SnackCount=0;
    mealCount=7;
    [frequencyTable reloadData];
    [self webServiveCall_SaveUserMealFrequency:mealCount with:SnackCount with:7];
}

-(IBAction)frequencyCheckUncheckButtonPressed:(UIButton*)sender{
    if ([sender.accessibilityHint isEqualToString:@"4meal"]) {
            int index = (int)sender.tag;
            NSMutableArray *fourMealArray=[[mealTypeDict objectForKey:@"4 Meals"]mutableCopy];
            NSLog(@"%@",[fourMealArray objectAtIndex:index]);
            if (index == 1) {
                selectedMeal =@"4meal";
                SnackCount=1;
                mealCount=3;
                [frequencyTable reloadData];
            }else if (index ==0){
                selectedMeal =@"4meal";
                SnackCount=0;
                mealCount=4;
                [frequencyTable reloadData];
            }
            [self webServiveCall_SaveUserMealFrequency:mealCount with:SnackCount with:4];
        }
      else if ([sender.accessibilityHint isEqualToString:@"5meal"]) {
            int index = (int)sender.tag;
            NSMutableArray *fiveMealArray=[[mealTypeDict objectForKey:@"5 Meals"]mutableCopy];
            NSLog(@"%@",[fiveMealArray objectAtIndex:index]);
            if (index == 1) {
                selectedMeal =@"5meal";
                SnackCount=2;
                mealCount=3;
                [frequencyTable reloadData];
                
            }else if (index ==0){
                selectedMeal =@"5meal";
                SnackCount=0;
                mealCount=5;
                [frequencyTable reloadData];
            }
            [self webServiveCall_SaveUserMealFrequency:mealCount with:SnackCount with:5];
        }
      else if ([sender.accessibilityHint isEqualToString:@"6meal"]) {
          int index = (int)sender.tag;
          NSMutableArray *sixMealArray=[[mealTypeDict objectForKey:@"6 Meals"]mutableCopy];
          NSLog(@"%@",[sixMealArray objectAtIndex:index]);
          if (index == 1) {
              selectedMeal =@"6meal";
              SnackCount=3;
              mealCount=3;
              [frequencyTable reloadData];
              
          }else if (index ==0){
              selectedMeal =@"6meal";
              SnackCount=0;
              mealCount=6;
              [frequencyTable reloadData];
          }
          [self webServiveCall_SaveUserMealFrequency:mealCount with:SnackCount with:6];
      }
      else if ([sender.accessibilityHint isEqualToString:@"2meal"]) {
          int index = (int)sender.tag;
          NSMutableArray *twoMealArray=[[mealTypeDict objectForKey:@"2 Meals"]mutableCopy];
          NSLog(@"%@",[twoMealArray objectAtIndex:index]);
           if (index ==0){
              selectedMeal =@"2meal";
              SnackCount=0;
              mealCount=2;
              [frequencyTable reloadData];
          }
          [self webServiveCall_SaveUserMealFrequency:mealCount with:SnackCount with:2];
      }
      else if ([sender.accessibilityHint isEqualToString:@"3meal"]) {
          int index = (int)sender.tag;
          NSMutableArray *threeMealArray=[[mealTypeDict objectForKey:@"3 Meals"]mutableCopy];
          NSLog(@"%@",[threeMealArray objectAtIndex:index]);
          if (index ==0){
              selectedMeal =@"3meal";
              SnackCount=0;
              mealCount=3;
              [frequencyTable reloadData];
          }
          [self webServiveCall_SaveUserMealFrequency:mealCount with:SnackCount with:3];
      }
      else if ([sender.accessibilityHint isEqualToString:@"7meal"]) {
          int index = (int)sender.tag;
          NSMutableArray *threeMealArray=[[mealTypeDict objectForKey:@"7 Meals"]mutableCopy];
          NSLog(@"%@",[threeMealArray objectAtIndex:index]);
          if (index ==0){
              selectedMeal =@"7meal";
              SnackCount=0;
              mealCount=7;
              [frequencyTable reloadData];
          }
          [self webServiveCall_SaveUserMealFrequency:mealCount with:SnackCount with:7];
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

-(IBAction)firstTimeButtonPressed:(UIButton*)sender{
    if (sender.tag == 0) {
        [self threeMealButtonPressed:nil];
    }else if (sender.tag == 1){
        [self fourMealButtonPressed:nil];
    }else if (sender.tag == 2){
        [self fiveMealButtonPressed:nil];
    }else{
        [self sixMealButtonPressed:nil];
    }
}
#pragma mark  -End

#pragma mark - Private Function

-(void)setUpView{//nss
    [twoMealButton setBackgroundColor:nil];
    [threeMealButton setBackgroundColor:nil];
    [fourMealButton setBackgroundColor:nil];
    [fiveMealButton setBackgroundColor:nil];
    [sixMealButton setBackgroundColor:nil];
    [sevenMealButton setBackgroundColor:nil];
    
    twoMealButton.selected =false;
    threeMealButton.selected=false;
    fourMealButton.selected=false;
    fiveMealButton.selected=false;
    sixMealButton.selected=false;
    sevenMealButton.selected=false;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary  *)change context:(void *)context
{
    //Whatever you do here when the reloadData finished
    float newHeight = frequencyTable.contentSize.height;
    frequencyHeightConstant.constant=newHeight;
}

-(void)webServiceCall_SquadGetRecommendedMealPlanForUser{//add9
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            apiCount++;
            if (contentView) {
                [contentView removeFromSuperview];
            }
            contentView = [Utility activityIndicatorView:self];
        });
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSMutableURLRequest *request = [Utility getRequest:@"" api:@"SquadGetRecommendedMealPlanForUser" append:[@"" stringByAppendingFormat:@"%@", [defaults objectForKey:@"ABBBCOnlineUserId"]] forAction:@"GET"];
        
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
                                                                     NSLog(@"SquadGetRecommendedMealPlanForUser- %@",responseDictionary);
                                                                     
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDictionary] && [[responseDictionary objectForKey:@"Success"] boolValue]) {
                                                                         getRecCommendedDict =[responseDictionary objectForKey:@"obj"];
                                                                         if (![Utility isEmptyCheck:getRecCommendedDict]) {
                                                                             mealCountDefault = [[getRecCommendedDict objectForKey:@"Session1MealFreq"]intValue];
                                                                             SnackCountDefault = [[getRecCommendedDict objectForKey:@"Session1SnackFreq"]intValue];
                                                                         }
                                                                         [self webservicecall_GetUserMealFrequencyAbsolute];
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
                                                                         //if([[self.navigationController.viewControllers firstObject] isKindOfClass:[TrailHomeViewController class]] || [defaults boolForKey:@"IsNonSubscribedUser"]){
                                                                         if(![Utility isSubscribedUser]){
                                                                             self->backToNutritionSettings.hidden = true;
                                                                             self->backToNutritionSettingsButtonHeightConstant.constant = 0;
                                                                         }else{
                                                                             if (self->stepnumber==0) {
                                                                                 self->backToNutritionSettings.hidden=false;
                                                                                 self->backToNutritionSettingsButtonHeightConstant.constant = 40;
                                                                             }else{
                                                                                 self->backToNutritionSettings.hidden=true;
                                                                                 self->backToNutritionSettingsButtonHeightConstant.constant = 0;
                                                                                 
                                                                             }
                                                                         }
                                                                         if (self->apiCount == 0) {
                                                                             [self->frequencyTable reloadData];
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
        
        [mainDict setObject:[NSNumber numberWithInteger:4] forKey:@"StepNumber"];
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
                                                                             MealVarietyViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MealVarietyView"];
                                                                             
                                                                             BOOL isanimated = YES;
                                                                             if (![[defaults objectForKey:@"IsAllStepComplete"]boolValue] && ![[defaults objectForKey:@"IsRedoDone"]boolValue]) {
                                                                                 isanimated = NO;
                                                                             }
                                                                             [self.navigationController pushViewController:controller animated:isanimated];
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
-(void)webServiveCall_SaveUserMealFrequency:(int)meal with:(int)snack with :(int)totalMeal{
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
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserID"];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss";
        NSString *todatDateString = [formatter stringFromDate:[NSDate date]];
        [mainDict setObject:todatDateString forKey:@"DateUpdated"];
        [mainDict setObject:[NSNumber numberWithInt:meal] forKey:@"MealCount"];
        [mainDict setObject:[NSNumber numberWithInt:snack] forKey:@"SnackCount"];
        [mainDict setObject:[NSNumber numberWithInt:totalMeal] forKey:@"TotalMeals"];
        isSetDeafault =false;
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"SaveUserMealFrequency" append:@""forAction:@"POST"];
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
                                                                             [self webSerViceCall_UpdateNutrationStep:false];
                                                                         }
                                                                         if (self->stepnumber == 0)
                                                                             [Utility msg:@"Saved Successful! Meals from yesterday and older will not be updated with the new settings" title:@"Success!" controller:self haveToPop:NO];
                                                                         
                                                                         if (self->isDefault) {
                                                                             if (!(self->stepnumber == 0)) {
                                                                                 [self webSerViceCall_UpdateNutrationStep:true];
                                                                             }else{
                                                                                 MealVarietyViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MealVarietyView"];
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
-(void)webservicecall_GetUserMealFrequencyAbsolute{
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
            NSMutableURLRequest *request = [Utility getRequest:@"" api:@"GetUserMealFrequencyAbsolute" append:[@"" stringByAppendingFormat:@"%@", [defaults objectForKey:@"ABBBCOnlineUserId"]] forAction:@"GET"];
            
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
                                                                             isSetDeafault=false;
                                                                             mealFrequencyDict=[responseDictionary objectForKey:@"obj"]
                                                                             ;
                                                                             if (![Utility isEmptyCheck:mealFrequencyDict]) {
                                                                                 if (![Utility isEmptyCheck:[mealFrequencyDict objectForKey:@"TotalMeals"]]) {
                                                                                     int selectedMealIndex = [[mealFrequencyDict objectForKey:@"TotalMeals"]intValue];
                                                                                     if (selectedMealIndex == 2) {
                                                                                         [twoMealButton setBackgroundColor:[Utility colorWithHexString:@"E425A0"]];
                                                                                         twoMealButton.selected = true;
                                                                                          selectedMeal =@"2meal";
                                                                                     }
                                                                                    else if (selectedMealIndex == 3) {
                                                                                         [threeMealButton setBackgroundColor:[Utility colorWithHexString:@"E425A0"]];
                                                                                         selectedMeal =@"3meal";
                                                                                        threeMealButton.selected =true;
                                                                                     }
                                                                                    else if (selectedMealIndex == 4) {
                                                                                        [fourMealButton setBackgroundColor:[Utility colorWithHexString:@"E425A0"]];
                                                                                         selectedMeal =@"4meal";
                                                                                        fourMealButton.selected =true;
                                                                                     }
                                                                                    else if (selectedMealIndex == 5) {
                                                                                        [fiveMealButton setBackgroundColor:[Utility colorWithHexString:@"E425A0"]];
                                                                                        selectedMeal =@"5meal";
                                                                                        fiveMealButton.selected =true;
                                                                                     }
                                                                                    else if (selectedMealIndex == 6) {
                                                                                      [sixMealButton setBackgroundColor:[Utility colorWithHexString:@"E425A0"]];
                                                                                        selectedMeal =@"6meal";
                                                                                        sixMealButton.selected =true;
                                                                                     }
                                                                                     else if (selectedMealIndex == 7) {
                                                                                           [sevenMealButton setBackgroundColor:[Utility colorWithHexString:@"E425A0"]];
                                                                                            selectedMeal =@"7meal";
                                                                                         sevenMealButton.selected =true;
                                                                                     }
                                                                                 }
                                                                                 if (![Utility isEmptyCheck:[mealFrequencyDict objectForKey:@"MealCount"]]) {
                                                                                     SnackCount =[[mealFrequencyDict objectForKey:@"SnackCount"]intValue];
                                                                                     mealCount =[[mealFrequencyDict objectForKey:@"MealCount"]intValue];
                                                                                    
                                                                                 }
                                                                             }
                                                                             
                                                                         }else{
                                                                             isSetDeafault=true;
                                                                             SnackCount=SnackCountDefault;//add9
                                                                             mealCount=mealCountDefault;
                                                                             int totalmeal = SnackCount+mealCount;
                                                                             if (![[defaults objectForKey:@"IsAllStepComplete"]boolValue] && ![[defaults objectForKey:@"IsRedoDone"]boolValue]) {
                                                                                if (totalmeal == 3){
                                                                                     selectedMeal = @"3meal";
                                                                                     self->firstTimeThreeMeals.selected = true;
                                                                                     [firstTimeThreeMeals setBackgroundColor:[Utility colorWithHexString:@"E425A0"]];
                                                                                 }else if (totalmeal == 4){
                                                                                     selectedMeal = @"4meal";
                                                                                     firstTimeThreeMealsOneSnack.selected = true;
                                                                                     [firstTimeThreeMealsOneSnack setBackgroundColor:[Utility colorWithHexString:@"E425A0"]];
                                                                                 }else if (totalmeal == 5){
                                                                                     selectedMeal = @"5meal";
                                                                                     firstTimeThreeMealsTwoSnack.selected = true;
                                                                                     [firstTimeThreeMealsTwoSnack setBackgroundColor:[Utility colorWithHexString:@"E425A0"]];
                                                                                 }else if (totalmeal == 6){
                                                                                     selectedMeal = @"6meal";
                                                                                     firstTimeSixSizedMeals.selected =true;
                                                                                     [firstTimeSixSizedMeals setBackgroundColor:[Utility colorWithHexString:@"E425A0"]];
                                                                                 }
                                                                             }else{
                                                                                 if (totalmeal == 2) {
                                                                                     selectedMeal = @"2meal";
                                                                                     [twoMealButton setBackgroundColor:[Utility colorWithHexString:@"E425A0"]];
                                                                                     twoMealButton.selected = true;
                                                                                 }else if (totalmeal == 3){
                                                                                     selectedMeal = @"3meal";
                                                                                     [threeMealButton setBackgroundColor:[Utility colorWithHexString:@"E425A0"]];
                                                                                     threeMealButton.selected = true;
                                                                                 }else if (totalmeal == 4){
                                                                                     selectedMeal = @"4meal";
                                                                                     [fourMealButton setBackgroundColor:[Utility colorWithHexString:@"E425A0"]];
                                                                                     fourMealButton.selected = true;
                                                                                 }else if (totalmeal == 5){
                                                                                     selectedMeal = @"5meal";
                                                                                     [fiveMealButton setBackgroundColor:[Utility colorWithHexString:@"E425A0"]];
                                                                                     fiveMealButton.selected = true;
                                                                                 }else if (totalmeal == 6){
                                                                                     selectedMeal = @"6meal";
                                                                                     [sixMealButton setBackgroundColor:[Utility colorWithHexString:@"E425A0"]];
                                                                                     sixMealButton.selected = true;
                                                                                 }else if (totalmeal == 7){
                                                                                     [sevenMealButton setBackgroundColor:[Utility colorWithHexString:@"E425A0"]];
                                                                                     selectedMeal = @"7meal";
                                                                                     sevenMealButton.selected=true;
                                                                                 }
                                                                             }
                                                                             
                                                                         }
                                                                         if (apiCount == 0) {
                                                                              [frequencyTable reloadData];
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
-(void)setUpMeal{
    twoMealButton.layer.borderColor = [Utility colorWithHexString:@"E425A0"].CGColor;
    twoMealButton.layer.borderWidth = 1;
    
    threeMealButton.layer.borderColor = [Utility colorWithHexString:@"E425A0"].CGColor;
    threeMealButton.layer.borderWidth = 1;
    
    fourMealButton.layer.borderColor = [Utility colorWithHexString:@"E425A0"].CGColor;
    fourMealButton.layer.borderWidth = 1;
    
    fiveMealButton.layer.borderColor = [Utility colorWithHexString:@"E425A0"].CGColor;
    fiveMealButton.layer.borderWidth = 1;
    
    sixMealButton.layer.borderColor = [Utility colorWithHexString:@"E425A0"].CGColor;
    sixMealButton.layer.borderWidth = 1;
    
    sevenMealButton.layer.borderColor = [Utility colorWithHexString:@"E425A0"].CGColor;
    sevenMealButton.layer.borderWidth = 1;
    
    
    
    twoMealButton.selected =false;
    threeMealButton.selected=false;
    fourMealButton.selected=false;
    fiveMealButton.selected=false;
    sixMealButton.selected=false;
    sevenMealButton.selected=false;
}
#pragma mark - End

#pragma mark  - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    //if([[self.navigationController.viewControllers firstObject] isKindOfClass:[TrailHomeViewController class]]){
 
    if (![[defaults objectForKey:@"IsAllStepComplete"]boolValue] && ![[defaults objectForKey:@"IsRedoDone"]boolValue]) {
        self->mealFrequencyScrollView.hidden = true;
        self->mealFirstTimeView.hidden = false;
        self->firstTimeThreeMeals.layer.borderColor = [Utility colorWithHexString:@"E425A0"].CGColor;
        self->firstTimeThreeMeals.layer.borderWidth=1;
        
        self->firstTimeThreeMealsOneSnack.layer.borderColor = [Utility colorWithHexString:@"E425A0"].CGColor;
        self->firstTimeThreeMealsOneSnack.layer.borderWidth=1;
        
        self->firstTimeThreeMealsTwoSnack.layer.borderColor = [Utility colorWithHexString:@"E425A0"].CGColor;
        self->firstTimeThreeMealsTwoSnack.layer.borderWidth=1;
        
        self->firstTimeSixSizedMeals.layer.borderColor = [Utility colorWithHexString:@"E425A0"].CGColor;
        self->firstTimeSixSizedMeals.layer.borderWidth=1;
        
    }else{
        self->mealFrequencyScrollView.hidden = false;
        self->mealFirstTimeView.hidden = true;
    }
    
    if(![Utility isSubscribedUser]){
        menuButton.hidden = true;
        footerConstant.constant = 0;
    }else{
        menuButton.hidden = false;
        footerConstant.constant = 75;
    }
    selectedIndex=-1;
    [self setUpMeal];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [frequencyTable addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionOld context:NULL];

    mealTypeDict =@{
                    @"2 Meals": @[
                                @"2 Even Sized Meals"
                                ],
                    @"3 Meals": @[
                                @"3 Even Sized Meals"
                                ],
                    @"4 Meals": @[
                                @"4 Even Sized Meals",
                                @"3 Meals and 1 Snacks"
                                ],
                    @"5 Meals": @[
                                @"5 Even Sized Meals",
                                @"3 Meals and 2 Snacks"
                                ],
                    @"6 Meals": @[
                                @"6 Even Sized Meals",
                                @"3 Meals and 3 Snacks"
                                ],
                    @"7 Meals": @[
                                @"7 Even Sized Meals"
                                ]
                    };
    apiCount= 0;
    isSetDeafault=true;
    isDefault =false;

    [self setUpView];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    [self webServiceCall_SquadGetRecommendedMealPlanForUser];
    [self webSerViceCall_SquadNutritionSettingStep];
    });
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [frequencyTable removeObserver:self forKeyPath:@"contentSize"];
}

#pragma mark - End

#pragma mark - Memory Warning

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma nark - End
#pragma mark - TableView DataSource & Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([selectedMeal isEqualToString:@"2meal"]){
        return 1;
    }else if ([selectedMeal isEqualToString:@"3meal"]){
        return 1;
    }else if ([selectedMeal isEqualToString:@"4meal"]){
        return 2;
    }else if ([selectedMeal isEqualToString:@"5meal"]){
        return 2;
    }else if ([selectedMeal isEqualToString:@"6meal"]){
        return 2;
    }else if ([selectedMeal isEqualToString:@"7meal"]){
        return 1;
    }else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *CellIdentifier =@"MealFrequencyTableViewCell";
    MealFrequencyTableViewCell *cell = (MealFrequencyTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // Configure the cell...
    if (cell == nil) {
        cell = [[MealFrequencyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.mealDetailsView.layer.borderColor = [Utility colorWithHexString:@"E425A0"].CGColor;
    cell.mealDetailsView.layer.borderWidth = 1;
    
    if ([selectedMeal isEqualToString:@"2meal"]) {
        NSMutableArray *mealTypeArray =[mealTypeDict objectForKey:@"2 Meals"];
        cell.frequencyMealLabel.text = [mealTypeArray objectAtIndex:indexPath.row];
        if (SnackCount==0 && mealCount==2) {
            cell.frequencyCheckUncheButton.selected=true;
            cell.mealDetailsView.layer.backgroundColor = [Utility colorWithHexString:@"E425A0"].CGColor;
            cell.frequencyMealLabel.textColor = [UIColor whiteColor];
        }
        
    }if ([selectedMeal isEqualToString:@"3meal"]) {
        NSMutableArray *mealTypeArray =[mealTypeDict objectForKey:@"3 Meals"];
        cell.frequencyMealLabel.text = [mealTypeArray objectAtIndex:indexPath.row];
        if (SnackCount==0 && mealCount == 3) {
            cell.frequencyCheckUncheButton.selected=true;
            cell.mealDetailsView.layer.backgroundColor = [Utility colorWithHexString:@"E425A0"].CGColor;
            cell.frequencyMealLabel.textColor = [UIColor whiteColor];
        }
    }
    if ([selectedMeal isEqualToString:@"4meal"]) {
        NSMutableArray *mealTypeArray =[mealTypeDict objectForKey:@"4 Meals"];
        cell.frequencyMealLabel.text = [mealTypeArray objectAtIndex:indexPath.row];
        if (SnackCount==0 && mealCount==4) {
            if (indexPath.row ==0) {
                cell.frequencyCheckUncheButton.selected=true;
                cell.mealDetailsView.layer.backgroundColor = [Utility colorWithHexString:@"E425A0"].CGColor;
                cell.frequencyMealLabel.textColor = [UIColor whiteColor];
            }else{
                cell.frequencyCheckUncheButton.selected=false;
                cell.mealDetailsView.layer.backgroundColor = [UIColor whiteColor].CGColor;
                cell.frequencyMealLabel.textColor = [Utility colorWithHexString:@"E425A0"];
            }
        }else if(SnackCount==1 && mealCount == 3){
            if (indexPath.row ==0) {
                cell.frequencyCheckUncheButton.selected=false;
                cell.mealDetailsView.layer.backgroundColor = [UIColor whiteColor].CGColor;
                cell.frequencyMealLabel.textColor = [Utility colorWithHexString:@"E425A0"];
            }else{
                cell.frequencyCheckUncheButton.selected=true;
                cell.mealDetailsView.layer.backgroundColor = [Utility colorWithHexString:@"E425A0"].CGColor;
                cell.frequencyMealLabel.textColor = [UIColor whiteColor];
            }
        }

    }
    if ([selectedMeal isEqualToString:@"5meal"]) {
        NSMutableArray *mealTypeArray =[mealTypeDict objectForKey:@"5 Meals"];
        cell.frequencyMealLabel.text = [mealTypeArray objectAtIndex:indexPath.row];
        if (SnackCount==0 && mealCount == 5) {
            if (indexPath.row ==0) {
                cell.frequencyCheckUncheButton.selected=true;
                cell.mealDetailsView.layer.backgroundColor = [Utility colorWithHexString:@"E425A0"].CGColor;
                cell.frequencyMealLabel.textColor = [UIColor whiteColor];
            }else{
                cell.frequencyCheckUncheButton.selected=false;
                cell.mealDetailsView.layer.backgroundColor = [UIColor whiteColor].CGColor;
                cell.frequencyMealLabel.textColor = [Utility colorWithHexString:@"E425A0"];
            }
        }else if(SnackCount==2 && mealCount==3){
            if (indexPath.row ==0) {
                cell.frequencyCheckUncheButton.selected=false;
                cell.mealDetailsView.layer.backgroundColor = [UIColor whiteColor].CGColor;
                cell.frequencyMealLabel.textColor = [Utility colorWithHexString:@"E425A0"];
            }else{
                cell.frequencyCheckUncheButton.selected=true;
                cell.mealDetailsView.layer.backgroundColor = [Utility colorWithHexString:@"E425A0"].CGColor;
                cell.frequencyMealLabel.textColor = [UIColor whiteColor];
            }
        }
    }
    if ([selectedMeal isEqualToString:@"6meal"]) {
        NSMutableArray *mealTypeArray =[mealTypeDict objectForKey:@"6 Meals"];
        cell.frequencyMealLabel.text = [mealTypeArray objectAtIndex:indexPath.row];
        
        if (SnackCount==0 && mealCount == 6) {
            if (indexPath.row ==0) {
                cell.frequencyCheckUncheButton.selected=true;
                cell.mealDetailsView.layer.backgroundColor = [Utility colorWithHexString:@"E425A0"].CGColor;
                cell.frequencyMealLabel.textColor = [UIColor whiteColor];
            }else{
                cell.frequencyCheckUncheButton.selected=false;
                cell.mealDetailsView.layer.backgroundColor = [UIColor whiteColor].CGColor;
                cell.frequencyMealLabel.textColor = [Utility colorWithHexString:@"E425A0"];
            }
        }else if(SnackCount==3 && mealCount == 3){
            if (indexPath.row ==0) {
                cell.frequencyCheckUncheButton.selected=false;
                cell.mealDetailsView.layer.backgroundColor = [UIColor whiteColor].CGColor;
                cell.frequencyMealLabel.textColor = [Utility colorWithHexString:@"E425A0"];
                
            }else{
                cell.frequencyCheckUncheButton.selected=true;
                cell.mealDetailsView.layer.backgroundColor = [Utility colorWithHexString:@"E425A0"].CGColor;
                cell.frequencyMealLabel.textColor = [UIColor whiteColor];
            }
        }
    }
    if ([selectedMeal isEqualToString:@"7meal"]) {
        NSMutableArray *mealTypeArray =[mealTypeDict objectForKey:@"7 Meals"];
        cell.frequencyMealLabel.text = [mealTypeArray objectAtIndex:indexPath.row];
        if (SnackCount==0 && mealCount ==7) {
            cell.frequencyCheckUncheButton.selected=true;
            cell.mealDetailsView.layer.backgroundColor = [Utility colorWithHexString:@"E425A0"].CGColor;
            cell.frequencyMealLabel.textColor = [UIColor whiteColor];
        }
    }
    cell.frequencyCheckUncheButton.tag=indexPath.row;
    cell.frequencyCheckUncheButton.accessibilityHint=selectedMeal;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *CellIdentifier =@"MealFrequencyTableViewCell";
    MealFrequencyTableViewCell *cell = (MealFrequencyTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // Configure the cell...
    if (cell == nil) {
        cell = [[MealFrequencyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.frequencyCheckUncheButton.tag=indexPath.row;
    cell.frequencyCheckUncheButton.accessibilityHint=selectedMeal;
    [self frequencyCheckUncheckButtonPressed:cell.frequencyCheckUncheButton];
}
@end
