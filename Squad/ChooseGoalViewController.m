//
//  ChooseGoalViewController.m
//  Squad
//
//  Created by AQB Mac 4 on 13/01/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import "ChooseGoalViewController.h"
#import "ChooseGoalTableViewCell.h"
#import "FatLossViewController.h"
#import "RateFitnessLevelViewController.h"
#import "CustomProgramSetupViewController.h"
#import "DietaryPreferenceViewController.h"
#import "NutritionSettingHomeViewController.h"
#import "ViewPersonalSessionViewController.h"
#import "CustomExerciseSettingsViewController.h"
#import "MovePersonalSessionViewController.h"

@interface ChooseGoalViewController (){
    IBOutlet NSLayoutConstraint *footerConstant;
    IBOutlet UIButton *menuButton;
    IBOutlet UITableView *table;
    NSArray *goalArray;
    NSArray *fatLossAmountArray;
    UIView *contentView;
    NSDictionary *squadProgram;
    IBOutlet UIView *nextPreviousContainerView;
    IBOutlet UILabel *headerLabel;


    IBOutlet UIButton *nextButton;
    IBOutlet UILabel *customHeaderPageCountLabel;
    IBOutlet UIButton *backButton;
    int stepnumber;
    IBOutlet UIButton *backtoNutritionButton;
    IBOutlet NSLayoutConstraint *backtoNutritionButtonHeightConstant;
    IBOutlet UIButton *applyButton;
    IBOutlet UILabel *applyTextLabel;
    IBOutlet UIView *applyLineView;
    IBOutlet UIButton *headerDetailsButton;
    NSInteger selectedIndex;
    BOOL autoNext;
}

@end

@implementation ChooseGoalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    autoNext = false;
    //if([[self.navigationController.viewControllers firstObject] isKindOfClass:[TrailHomeViewController class]]){
    if(![Utility isSubscribedUser]){
        menuButton.hidden = true;
        footerConstant.constant = 0;
    }else{
        menuButton.hidden = false;
        footerConstant.constant = 75;
    }
    if (_isNutritionSettings) {
       // nextPreviousContainerView.backgroundColor = [UIColor colorWithRed:111.0f/255.0f green:205.0f/255.0f blue:205.0f/255.0f alpha:1];
        headerLabel.text = @"Choose Your Goal";
        [headerDetailsButton setTitle:@"NUTRITION SETTINGS" forState:UIControlStateNormal];
        //@"CUSTOM NUTRITION PLAN SET UP"
    }else{
//        nextPreviousContainerView.backgroundColor = [UIColor colorWithRed:155.0f/255.0f green:190.0f/255.0f blue:250.0f/255.0f alpha:1];
        headerLabel.text = @"CUSTOM EXERCISE PLAN SET UP";
        [headerDetailsButton setTitle:@"EXERCISE SETTINGS" forState:UIControlStateNormal];
    }
    table.estimatedRowHeight=40;
    table.rowHeight = UITableViewAutomaticDimension;
    if (_isNutritionSettings) { //add
        customHeaderPageCountLabel.text=@"1 of 5";
    }else {
        nextButton.hidden = true;
    }
    
    
    goalArray = @[
                  @{
                      @"goalName" : @"Fat Loss",
                      @"isdropdown" : @true,
                      @"key" : @"Fat_Loss",
                      @"value" : @1
                      },@{
                      @"goalName" : @"Muscle Gain",
                      @"isdropdown" : @false,
                      @"key" : @"Muscle_Gain_and_Shape",
                      @"value" : @2
                      },@{
                      @"goalName" : @"Fat Loss and Toning",
                      @"isdropdown" : @true,
                      @"key" : @"Fat_Loss_and_Muscle_Gain",
                      @"value" : @3
                      },@{
                      @"goalName" : @"Improve Health and Fitness",
                      @"isdropdown" : @false,
                      @"key" : @"Improve_Health_and_Fitness_only",
                      @"value" : @4
                      },@{
                      @"goalName" : @"Post Pregnancy",
                      @"isdropdown" : @false,
                      @"key" : @"Post_Pregnancy",
                      @"value" : @5
                      }
                  ];
    fatLossAmountArray = @[
                           @{
                               @"fatLossAmount" : @"0-2kg",
                               @"isdropdown" : @false,
                               @"key" : @"FatLoss_0_2",
                               @"value" : @1
                               },@{
                               @"fatLossAmount" : @"3-5kg",
                               @"isdropdown" : @false,
                               @"key" : @"FatLoss_3_5",
                               @"value" : @2
                               },@{
                               @"fatLossAmount" : @"5-10kg",
                               @"isdropdown" : @false,
                               @"key" : @"FatLoss_5_10",
                               @"value" : @3
                               },@{
                               @"fatLossAmount" : @"10-15kg",
                               @"isdropdown" : @false,
                               @"key" : @"FatLoss_10_15",
                               @"value" : @4
                               },@{
                               @"fatLossAmount" : @"20+kg",
                               @"isdropdown" : @false,
                               @"key" : @"FatLoss_20_Plus",
                               @"value" : @5
                               }
                           ];
    
    [self applyButtonFunction:NO];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    selectedIndex = -1;
    if (_isNutritionSettings){
//        //if([[self.navigationController.viewControllers firstObject] isKindOfClass:[TrailHomeViewController class]] || [defaults boolForKey:@"IsNonSubscribedUser"]){
//        if([defaults boolForKey:@"IsNonSubscribedUser"]){
//            backButton.hidden=false;
//        }else{
//            backButton.hidden=true;
//        }
        backButton.hidden=true;
        [self webSerViceCall_SquadNutritionSettingStep];
        //add22
    }else{
        //if([[self.navigationController.viewControllers firstObject] isKindOfClass:[TrailHomeViewController class]] || [defaults boolForKey:@"IsNonSubscribedUser"]){
        if(![Utility isSubscribedUser]){
            backtoNutritionButton.hidden = true;
            backtoNutritionButtonHeightConstant.constant = 0;
        }else{
            if ([defaults integerForKey:@"CustomExerciseStepNumber"] == 0) {
                backtoNutritionButton.hidden=false;
                [backtoNutritionButton setTitle:@"BACK TO EXERCISE SETTINGS" forState:UIControlStateNormal];
                backtoNutritionButtonHeightConstant.constant = 40;
            } else {
                backtoNutritionButton.hidden = true;
                backtoNutritionButtonHeightConstant.constant = 0;
            }
        }
        backButton.hidden=false;
    }
    
    if(![Utility isEmptyCheck:self->squadProgram]){
        self->nextButton.hidden = false;
    }else{
        self->nextButton.hidden = true;
    }
    
    [self getSquadCurrentProgram];
    
    
    
}
#pragma mark - IBAction
-(IBAction)homeButtonPressed:(UIButton*)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(IBAction)backToNutritionSettings:(id)sender{
    if (_isNutritionSettings) {
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
    }else {
        BOOL isexist=false;
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[CustomExerciseSettingsViewController class]]) {
                [self.navigationController popToViewController:controller
                                                      animated:YES];
                isexist=true;
                break;
                
            }
        }
        if (!isexist) {
            CustomExerciseSettingsViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CustomExerciseSettings"];
            [self.navigationController pushViewController:controller animated:YES];
        }
    }
}
- (IBAction)menuButtonPressed:(id)sender {
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
    [self.slidingViewController resetTopViewAnimated:YES];
}

-(IBAction)backButtonPressed:(id)sender{
    if (!_isNutritionSettings) {
        CustomProgramSetupViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CustomProgramSetup"];
        [self.navigationController pushViewController:controller animated:NO];
    }else{
//        //if([[self.navigationController.viewControllers firstObject] isKindOfClass:[TrailHomeViewController class]] || [defaults boolForKey:@"IsNonSubscribedUser"]){
//        if([defaults boolForKey:@"IsNonSubscribedUser"]){
//            MovePersonalSessionViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MovePersonalSession"];
//            //    controller.responseObjArray = responseObjArray;
//            [self.navigationController pushViewController:controller animated:YES];
//        }else{
//            backButton.hidden=true;
//        }
        
    }
}
-(IBAction)nextButtonPressed:(id)sender{
    if (![Utility isEmptyCheck:squadProgram]) {//new1
        if (_isNutritionSettings) {
            if (!(stepnumber == 0)) {
                [self webSerViceCall_UpdateNutrationStep:true];//updatestep
            }else{
                DietaryPreferenceViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DietaryPreferenceView"];

                [self.navigationController pushViewController:controller animated:YES];
            }
        }else {
            [self updatedUserProgramSetupStep];
            RateFitnessLevelViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"RateFitnessLevel"];
            controller.isRateFitness = YES;
            [self.navigationController pushViewController:controller animated:YES];
        }

    }else{
        [Utility msg:@"Please choose the option that best suits your goal" title:@"Alert" controller:self haveToPop:NO];
    }
}

-(IBAction)applyButtonPressed:(UIButton*)sender{
    if (![Utility isEmptyCheck:[goalArray objectAtIndex:sender.tag]]) {
        [self saveSquadCurrentProgram:[goalArray objectAtIndex:sender.tag]];
    }
}
#pragma -mark End
#pragma mark  -Private Function

-(void)applyButtonFunction:(BOOL)isActive{
    if (isActive) {
        applyButton.userInteractionEnabled = true;
        applyTextLabel.textColor = [UIColor whiteColor];
        applyLineView.backgroundColor = [UIColor whiteColor];
    }else{
        applyButton.userInteractionEnabled = false;
        applyTextLabel.textColor = [Utility colorWithHexString:@"f087cb"];
        applyLineView.backgroundColor = [Utility colorWithHexString:@"f087cb"];
    }
}
#pragma mark - APICall
-(void)saveSquadCurrentProgram:(NSDictionary *)dict{
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
        
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        [mainDict setObject:[dict objectForKey:@"value"] forKey:@"ProgramId"];
        [mainDict setObject:[NSNumber numberWithBool:YES] forKey:@"IsPersonalised"];
        [mainDict setObject:[NSNumber numberWithBool:YES] forKey:@"NeedToUpdate"];
        [mainDict setObject:[NSNumber numberWithInt:0] forKey:@"WeightLossRange"];
        [mainDict setObject:[NSNumber numberWithBool:YES] forKey:@"DifficultyHoldingMuscle"];

        
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"SaveSquadProgramApiCall" append:@""forAction:@"POST"];
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
                                                                         nextButton.hidden = false;
                                                                         if (_isNutritionSettings) {
                                                                             if (!(stepnumber == 0)) {
                                                                                 [self webSerViceCall_UpdateNutrationStep:false];//updatestep
                                                                             }
                                                                             [self getSquadCurrentProgram];
                                                                             autoNext = true;
                                                                             //????saugata
//                                                                             [self nextButtonPressed:0];//20/dec feedback
                                                                             if (!_isNutritionSettings) { //add
                                                                                 RateFitnessLevelViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"RateFitnessLevel"];
                                                                                 controller.isRateFitness=true;
                                                                                 [self.navigationController pushViewController:controller animated:YES];
                                                                             }
                                                                         }else {
                                                                             [self updatedUserProgramSetupStep];
                                                                             RateFitnessLevelViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"RateFitnessLevel"];
                                                                             controller.isRateFitness=true;
                                                                             [self.navigationController pushViewController:controller animated:YES];
                                                                         }
//                                                                         [table reloadData];
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
-(void)getSquadCurrentProgram{
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
        
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
                
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetSquadCurrentProgramApiCall" append:@""forAction:@"POST"];
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
                                                                         self->squadProgram =[responseDict objectForKey:@"SquadProgram"];
                                                                         [self->table reloadData];
                                                                         
                                                                         if(![Utility isEmptyCheck:self->squadProgram]){
                                                                             self->nextButton.hidden = false;
                                                                         }else{
                                                                             self->nextButton.hidden = true;
                                                                         }
                                                                         if (self->autoNext) {
                                                                             [self nextButtonPressed:0];//31/01/19
                                                                             self->autoNext = false;
                                                                         }
                                                                     }
                                                                     else{
                                                                         
                                                                         [self->table reloadData];
                                                                         //[Utility msg:[responseDict objectForKey:@"ErrorMessage"] title:@"Error !" controller:self haveToPop:NO];
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
-(void) updatedUserProgramSetupStep {
    if ([defaults integerForKey:@"CustomExerciseStepNumber"] > 0) {
        if (Utility.reachable) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (contentView) {
                    [contentView removeFromSuperview];
                }
                contentView = [Utility activityIndicatorView:self];
            });
            
            NSURLSession *customSession = [NSURLSession sharedSession];
            
            NSError *error;
            
            NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
            [mainDict setObject:AccessKey forKey:@"Key"];
            [mainDict setObject:[NSNumber numberWithInteger:3] forKey:@"StepNumber"];
            [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
            [mainDict setObject:[defaults objectForKey:@"UserID"] forKey:@"UserID"];
            
            NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
            if (error) {
                [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
                return;
            }
            NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
            
            NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"UpdatedUserProgramSetupStep" append:@""forAction:@"POST"];
            NSURLSessionDataTask * dataTask =[customSession dataTaskWithRequest:request
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
                                                                              
                                                                          }
                                                                          else{
                                                                              [Utility msg:[responseDict objectForKey:@"ErrorMessage"] title:@"Error!" controller:self haveToPop:NO];
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
-(void)webSerViceCall_UpdateNutrationStep:(BOOL)isSave{ //add
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
            
            [mainDict setObject:[NSNumber numberWithInteger:2] forKey:@"StepNumber"];
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
                                                                             if (isSave) {
                                                                                 DietaryPreferenceViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DietaryPreferenceView"];

                                                                                 [self.navigationController pushViewController:controller animated:YES];
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
-(void)webSerViceCall_SquadNutritionSettingStep{
   
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
                                                                     if (contentView) {
                                                                         [contentView removeFromSuperview];
                                                                     }
                                                                     if(error == nil)
                                                                     {
                                                                         NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                         NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                         if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"SuccessFlag"]boolValue]) {
                                                                             stepnumber=[[responseDict objectForKey:@"StepNumber"]intValue];
                                                                             //if([[self.navigationController.viewControllers firstObject] isKindOfClass:[TrailHomeViewController class]] || [defaults boolForKey:@"IsNonSubscribedUser"]){
                                                                             if(![Utility isSubscribedUser]){

                                                                                 backtoNutritionButton.hidden = true;
                                                                                 backtoNutritionButtonHeightConstant.constant = 0;
                                                                             }else{
                                                                                 if (stepnumber==0) {
                                                                                     backtoNutritionButton.hidden=false;
                                                                                     [backtoNutritionButton setTitle:@"BACK TO NUTRITION SETTINGS" forState:UIControlStateNormal];
                                                                                     backtoNutritionButtonHeightConstant.constant = 40;
                                                                                 } else {
                                                                                     backtoNutritionButton.hidden = true;
                                                                                     backtoNutritionButtonHeightConstant.constant = 0;
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


#pragma -mark End

#pragma mark - TableView Datasource & Delegate


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return goalArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *CellIdentifier =@"ChooseGoalTableViewCell";
    ChooseGoalTableViewCell *cell = (ChooseGoalTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // Configure the cell...
    if (cell == nil) {
        cell = [[ChooseGoalTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.borderView.layer.borderColor = [Utility colorWithHexString:@"E425A0"].CGColor;
    cell.borderView.layer.borderWidth = 1;
    NSDictionary *dict = [goalArray objectAtIndex:indexPath.row];
    if (![Utility isEmptyCheck:dict]) {
        cell.goalName.text = [Utility isEmptyCheck:[dict objectForKey:@"goalName"]] ?@"": [dict objectForKey:@"goalName"];
        
        if ([[dict objectForKey:@"isdropdown"] boolValue]) {
            cell.arrowButtonWidhConstraint.constant = 30;
            cell.selectedFatLossAmountLeadingConstraint.constant = 8;
            cell.selectedFatLossAmountWidthConstraint.constant = 85;
            if (![Utility isEmptyCheck:squadProgram] && [[squadProgram objectForKey:@"WeightLossRange"] intValue] > 0 && [[squadProgram objectForKey:@"ProgramId"] intValue]==[[dict objectForKey:@"value"] intValue] ) {
                NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"value == %@", [squadProgram objectForKey:@"WeightLossRange"]];
                NSArray *filterArray = [fatLossAmountArray filteredArrayUsingPredicate:predicate1];
                if (filterArray.count > 0) {
                    NSDictionary *selectedDictionary = [filterArray objectAtIndex:0];
                    cell.selectedFatLossAmount.text = [selectedDictionary objectForKey:@"fatLossAmount"];

                }else{
                    cell.selectedFatLossAmountLeadingConstraint.constant = 0;
                    cell.selectedFatLossAmountWidthConstraint.constant = 0;
                }
            }else{
                cell.selectedFatLossAmountLeadingConstraint.constant = 0;
                cell.selectedFatLossAmountWidthConstraint.constant = 0;
            }
            
            
        }else{
            cell.arrowButtonWidhConstraint.constant = 0;
            cell.selectedFatLossAmountLeadingConstraint.constant = 0;
            cell.selectedFatLossAmountWidthConstraint.constant = 0;
        }
    }
    if ((![Utility isEmptyCheck:squadProgram] && [[squadProgram objectForKey:@"ProgramId"] intValue]==[[dict objectForKey:@"value"] intValue]) && selectedIndex == -1) {
//        [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        nextButton.hidden = false;
        
        cell.borderView.backgroundColor = [Utility colorWithHexString:@"E425A0"];
        cell.goalName.textColor = [UIColor whiteColor];
        cell.selectedFatLossAmount.textColor = [UIColor whiteColor];
        [cell.arrowButton setImage:[[UIImage imageNamed:@"right_arr.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        [cell.arrowButton setTintColor:[UIColor whiteColor]];
        [self applyButtonFunction:YES];
        
    }else if(selectedIndex == indexPath.row){
        cell.borderView.backgroundColor = [Utility colorWithHexString:@"E425A0"];
        cell.goalName.textColor = [UIColor whiteColor];
        cell.selectedFatLossAmount.textColor = [UIColor whiteColor];
        [cell.arrowButton setImage:[[UIImage imageNamed:@"right_arr.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        [cell.arrowButton setTintColor:[UIColor whiteColor]];
        [self applyButtonFunction:YES];
    }else{
        cell.borderView.backgroundColor = [UIColor whiteColor];
        cell.goalName.textColor = [Utility colorWithHexString:@"E425A0"];
        cell.selectedFatLossAmount.textColor = [Utility colorWithHexString:@"E425A0"];
    }
    
    //ah new

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    applyButton.tag = indexPath.row;
    selectedIndex =indexPath.row;
    if (![Utility isEmptyCheck:[goalArray objectAtIndex:indexPath.row]]) {
        NSDictionary *dict = [goalArray objectAtIndex:indexPath.row];
        if ([[dict objectForKey:@"isdropdown"] boolValue]) {
            if ([[dict objectForKey:@"value"] intValue] == 1 || [[dict objectForKey:@"value"] intValue] == 3){
                FatLossViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"FatLoss"];
                controller.fatLossDict = dict;
                controller.squadProgram = squadProgram;
                controller.fatLossAmountArray=fatLossAmountArray;
                if (_isNutritionSettings) { //add
                    controller.isNutritionSettings =true;
                }
                [self.navigationController pushViewController:controller animated:YES];
            }
        }else{
            [table reloadData];
        }
    }
}
#pragma -mark End

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
