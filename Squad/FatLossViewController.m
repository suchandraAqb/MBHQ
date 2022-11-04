//
//  FatLossViewController.m
//  Squad
//
//  Created by AQB Mac 4 on 17/01/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import "FatLossViewController.h"
#import "MasterMenuViewController.h"
#import "ChooseGoalTableViewCell.h"
#import "RateFitnessLevelViewController.h"
#import "ChooseGoalViewController.h"
#import "DietaryPreferenceViewController.h"
#import "ViewPersonalSessionViewController.h"
#import "CustomExerciseSettingsViewController.h"
#import "NutritionSettingHomeViewController.h"

@interface FatLossViewController (){
    IBOutlet NSLayoutConstraint *footerConstant;
    IBOutlet UIButton *menuButton;
    IBOutlet UITableView *table;
    IBOutlet UILabel *header;
    IBOutlet UILabel *headerLabel;

    UIView *contentView;
    
    IBOutlet UIButton *nextButton;
    IBOutlet UILabel *customHeaderPageCountLabel;   //add
    IBOutlet UIView *nextPreviousContainerView;
    IBOutlet UIButton *applyButton;
    IBOutlet UILabel *applyTextLabel;
    IBOutlet UIView *applyLineView;

    IBOutlet UIButton *backToExSettingsButton;
    IBOutlet NSLayoutConstraint *backExButtonHeightConstraint;
    IBOutlet UIButton *headerDetailsButton;
    int stepnumber;
    int apiCount;
    NSInteger selectedIndex;

}

@end

@implementation FatLossViewController
@synthesize fatLossDict,squadProgram,fatLossAmountArray;
- (void)viewDidLoad {
    [super viewDidLoad];
    selectedIndex=-1;
    [self applyButtonFunction:NO];
    //if([[self.navigationController.viewControllers firstObject] isKindOfClass:[TrailHomeViewController class]]){
    if(![Utility isSubscribedUser]){
        menuButton.hidden = true;
        footerConstant.constant = 0;
    }else{
        menuButton.hidden = false;
        footerConstant.constant = 75;
    }
    if (_isNutritionSettings) {
//        nextPreviousContainerView.backgroundColor = [UIColor colorWithRed:111.0f/255.0f green:205.0f/255.0f blue:205.0f/255.0f alpha:1];
        headerLabel.text = @"Choose Your Goal";
        [headerDetailsButton setTitle:@"NUTRITION SETTINGS" forState:UIControlStateNormal];
        //@"CUSTOM NUTRITION PLAN SET UP"
    }else{
//        nextPreviousContainerView.backgroundColor = [UIColor colorWithRed:155.0f/255.0f green:190.0f/255.0f blue:250.0f/255.0f alpha:1];
        headerLabel.text = @"CUSTOM EXERCISE PLAN SET UP";
        [headerDetailsButton setTitle:@"EXERCISE SETTINGS" forState:UIControlStateNormal];
    }
    apiCount = 0;
    table.estimatedRowHeight=40;
    table.rowHeight = UITableViewAutomaticDimension;
    if (![Utility isEmptyCheck:fatLossDict]) {
        NSString *title = [fatLossDict objectForKey:@"goalName"];
        if (![Utility isEmptyCheck:title]) {
            header.text = title;
        }else{
            header.text = @"";
        }
    }
    
    if (_isNutritionSettings) { //add
        customHeaderPageCountLabel.text=@"";
        [backToExSettingsButton setTitle:@"BACK TO NUTRITION SETTINGS" forState:UIControlStateNormal];
        [self webSerViceCall_SquadNutritionSettingStep];
    }else{
        //if([[self.navigationController.viewControllers firstObject] isKindOfClass:[TrailHomeViewController class]] || [defaults boolForKey:@"IsNonSubscribedUser"]){
        if(![Utility isSubscribedUser]){
            backToExSettingsButton.hidden = true;
            backExButtonHeightConstraint.constant = 0;
        }else{
            if ([defaults integerForKey:@"CustomExerciseStepNumber"] == 0) {
                backToExSettingsButton.hidden=false;
                backExButtonHeightConstraint.constant = 40;
            } else {
                backToExSettingsButton.hidden = true;
                backExButtonHeightConstraint.constant = 0;
            }
        }
    }
    nextButton.hidden = true;
}
#pragma -mark IBAction

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
        [mainDict setObject:[fatLossDict objectForKey:@"value"] forKey:@"ProgramId"];
        [mainDict setObject:[NSNumber numberWithBool:YES] forKey:@"IsPersonalised"];
        [mainDict setObject:[NSNumber numberWithBool:YES] forKey:@"NeedToUpdate"];
        [mainDict setObject:[dict objectForKey:@"value"] forKey:@"WeightLossRange"];
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
                                                                         
                                                                         if (!_isNutritionSettings) {
                                                                             [self updatedUserProgramSetupStep];
                                                                             RateFitnessLevelViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"RateFitnessLevel"];
                                                                             controller.isRateFitness=true;
                                                                             [self.navigationController pushViewController:controller animated:YES];
                                                                         }else{
                                                                             nextButton.hidden = false;
                                                                             [self webSerViceCall_UpdateNutrationStep:false];

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

-(IBAction)homeButtonPressed:(UIButton*)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)menuButtonPressed:(id)sender {
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
    [self.slidingViewController resetTopViewAnimated:YES];
}

-(IBAction)backButtonPressed:(id)sender{
//    [self.navigationController popViewControllerAnimated:YES];

    ChooseGoalViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ChooseGoal"];
    if (_isNutritionSettings) {
        controller.isNutritionSettings=true;
    
    }
    [self.navigationController pushViewController:controller animated:NO];
}
-(IBAction)nextButtonPressed:(id)sender{
    if (_isNutritionSettings) {
        if (!(stepnumber == 0)) {
            [self webSerViceCall_UpdateNutrationStep:true];//updatestep
        }else{
            DietaryPreferenceViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DietaryPreferenceView"];
            [self.navigationController pushViewController:controller animated:YES];
        }
    }else{
        [self updatedUserProgramSetupStep];
        RateFitnessLevelViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"RateFitnessLevel"];
        controller.isRateFitness=true;
        [self.navigationController pushViewController:controller animated:YES];
    }
}
-(IBAction)backToExerciseSettings:(id)sender {//ss15
    BOOL isexist=false;
    if (_isNutritionSettings){
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
        
    }else{
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
-(IBAction)applyButtonPressed:(UIButton*)sender{
    NSDictionary *dict = [fatLossAmountArray objectAtIndex:sender.tag];
    if (![Utility isEmptyCheck:dict]) {
        [self saveSquadCurrentProgram:dict];
    }
}
#pragma -mark End

#pragma mark - Private Function
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
                                                                             backToExSettingsButton.hidden=false;
                                                                         }else{
                                                                             backToExSettingsButton.hidden=true;
                                                                         }
                                                                         if (apiCount == 0) {
                                                                             [table reloadData];
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

-(void)webSerViceCall_UpdateNutrationStep:(BOOL)isSave{ //add
    if (stepnumber !=0){
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
            
            [mainDict setObject:[NSNumber numberWithInteger:3] forKey:@"StepNumber"];
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
                                                                             }else{
                                                                                 [self nextButtonPressed:0];
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
    }else{
        [self nextButtonPressed:0];
    }
    
}
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
#pragma mark  -End
#pragma mark - TableView Datasource & Delegate


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return fatLossAmountArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *CellIdentifier =@"ChooseGoalTableViewCell";
    ChooseGoalTableViewCell *cell = (ChooseGoalTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // Configure the cell...
    if (cell == nil) {
        cell = [[ChooseGoalTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSDictionary *dict = [fatLossAmountArray objectAtIndex:indexPath.row];
    if (![Utility isEmptyCheck:dict]) {
        cell.goalName.text = [Utility isEmptyCheck:[dict objectForKey:@"fatLossAmount"]] ?@"": [dict objectForKey:@"fatLossAmount"];
        if ([[dict objectForKey:@"isdropdown"] boolValue]) {
            cell.arrowButtonWidhConstraint.constant = 30;
        }else{
            cell.arrowButtonWidhConstraint.constant = 0;
        }
        if (![Utility isEmptyCheck:squadProgram] && [[squadProgram objectForKey:@"WeightLossRange"] intValue]==[[dict objectForKey:@"value"] intValue] && [[squadProgram objectForKey:@"ProgramId"] intValue]==[[fatLossDict objectForKey:@"value"] intValue] && selectedIndex == -1 ) {
            
//            [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            nextButton.hidden = false;
            cell.borderView.backgroundColor = [Utility colorWithHexString:@"E425A0"];
            cell.goalName.textColor = [UIColor whiteColor];
            [self applyButtonFunction:YES];
            
        }else if(selectedIndex == indexPath.row){
            cell.borderView.backgroundColor = [Utility colorWithHexString:@"E425A0"];
            cell.goalName.textColor = [UIColor whiteColor];
            [self applyButtonFunction:YES];
        }else{
            cell.borderView.backgroundColor = [UIColor whiteColor];
            cell.goalName.textColor = [Utility colorWithHexString:@"E425A0"];
        }
    }
    
    //ah new
//    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    cell.goalName.highlightedTextColor = [UIColor whiteColor];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    applyButton.tag = indexPath.row;
    selectedIndex = indexPath.row;
    [table reloadData];
}

#pragma -mark End

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
