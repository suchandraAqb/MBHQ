//
//  TrailHomeViewController.m
//  Squad
//
//  Created by AQB Mac 4 on 18/9/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import "TrailHomeViewController.h"
#import "CustomExerciseSettingsViewController.h"
#import "NutritionSettingHomeViewController.h"
#import "SignupWithEmailViewController.h"
#import "CustomProgramSetupViewController.h"
#import "CongratulationViewController.h"
#import "NourishViewController.h"
#import "TrainHomeViewController.h"

@interface TrailHomeViewController (){
    IBOutlet UIButton *exerciseSettingButton;
    IBOutlet UIButton *nutritionSettingButton;
    IBOutlet UIButton *logoButton;
    int nutritionSettingStepNumber;
    int exerciseSettingStepNumber;
    UIView *contentView;
    int apiCount;


}

@end

@implementation TrailHomeViewController
@synthesize ofType;

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@",[self.navigationController viewControllers]);
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self performSelector:@selector(getStep)
               withObject:self
               afterDelay:1];
    
 }
-(void)getStep{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ECSlidingViewController *slider=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SlidingView"];
    if ([ofType isKindOfClass:[CustomProgramSetupViewController class]] || [ofType isKindOfClass:[NutritionSettingHomeViewController class]]) {
        CustomProgramSetupViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CustomProgramSetup"];
        NavigationViewController *nav = [[storyboard instantiateViewControllerWithIdentifier:@"NavigationViewController"]initWithRootViewController:controller];
        if ([ofType isKindOfClass:[CustomProgramSetupViewController class]]) {
            [defaults setObject:@"Exercise" forKey:@"SendToCustomPlan"];
        }else{
            [defaults setObject:@"Nutrition" forKey:@"SendToCustomPlan"];
        }
        [slider setTopViewController:nav];
        [slider resetTopViewAnimated:YES];
        [self.navigationController pushViewController:slider animated:YES];
    }
//    else if ([ofType isKindOfClass:[NutritionSettingHomeViewController class]]){
//        NutritionSettingHomeViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NutritionSettingHomeView"];
//        NavigationViewController *nav = [[storyboard instantiateViewControllerWithIdentifier:@"NavigationViewController"]initWithRootViewController:controller];
//        [slider setTopViewController:nav];
//        [slider resetTopViewAnimated:YES];
//        [self.navigationController pushViewController:slider animated:YES];
//    }
//    else if([ofType isKindOfClass:[CustomNutritionPlanListViewController class]]){
//        NourishViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Nourish"];
//        controller.isFromNotification = YES;
//        NavigationViewController *nav = [[storyboard instantiateViewControllerWithIdentifier:@"NavigationViewController"]initWithRootViewController:controller];
//        [slider setTopViewController:nav];
//        [slider resetTopViewAnimated:YES];
//        [self.navigationController pushViewController:slider animated:YES];
//    }
    else if([ofType isKindOfClass:[TrainHomeViewController class]]){
        TrainHomeViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"TrainHome"];
        controller.haveToSendToExerciseSettings = YES;
        [defaults setObject:@"Exercise" forKey:@"SendToCustomPlan"];
        
        NavigationViewController *nav = [[storyboard instantiateViewControllerWithIdentifier:@"NavigationViewController"]initWithRootViewController:controller];
        [slider setTopViewController:nav];
        [slider resetTopViewAnimated:YES];
        [self.navigationController pushViewController:slider animated:YES];
    }else if([ofType isKindOfClass:[CustomNutritionPlanListViewController class]]){
        
        NourishViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Nourish"];
        controller.isFromMealMatchNotification = YES;
        
//        CustomNutritionPlanListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CustomNutritionPlanList"];
        [defaults setObject:@"Nutrition" forKey:@"SendToCustomPlan"];
        NavigationViewController *nav = [[storyboard instantiateViewControllerWithIdentifier:@"NavigationViewController"]initWithRootViewController:controller];
        [slider setTopViewController:nav];
        [slider resetTopViewAnimated:YES];
        [self.navigationController pushViewController:slider animated:YES];
    }else{
        HomePageViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"HomePage"];
        NavigationViewController *nav = [[storyboard instantiateViewControllerWithIdentifier:@"NavigationViewController"]initWithRootViewController:controller];
        [slider setTopViewController:nav];
        [slider resetTopViewAnimated:YES];
        [self.navigationController pushViewController:slider animated:YES];
    }
//    nutritionSettingStepNumber = -1000;
//    exerciseSettingStepNumber = -1000;
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        [self checkStepNumberForSetupWithAPI:@"CheckStepNumberForSetup"];
//        [self webSerViceCall_SquadNutritionSettingStep];
//    });

}
- (IBAction)logoButtonPressed:(UIButton *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(IBAction)itemButtonPressed:(UIButton *)sender{
    if (sender.tag == 0) {
        CustomExerciseSettingsViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CustomExerciseSettings"];
        [self.navigationController pushViewController:controller animated:YES];

    }else{
        NutritionSettingHomeViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NutritionSettingHomeView"];
        [self.navigationController pushViewController:controller animated:YES];
    }
    
}
#pragma mark -API Call
-(void)checkStepComplete{
    if (nutritionSettingStepNumber == 0 && exerciseSettingStepNumber == 0) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ECSlidingViewController *slider=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SlidingView"];
        HomePageViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"HomePage"];
        NavigationViewController *nav = [[storyboard instantiateViewControllerWithIdentifier:@"NavigationViewController"]initWithRootViewController:controller];
        [slider setTopViewController:nav];
        [slider resetTopViewAnimated:YES];
        [self.navigationController pushViewController:slider animated:YES];
    }else{
        if (apiCount == 0) {
            if ([ofType isKindOfClass:[CustomProgramSetupViewController class]]) {
                CustomProgramSetupViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CustomProgramSetup"];
                [self.navigationController pushViewController:controller animated:YES];
            }else if ([ofType isKindOfClass:[NutritionSettingHomeViewController class]]){
                NutritionSettingHomeViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NutritionSettingHomeView"];
                [self.navigationController pushViewController:controller animated:YES];
            }else{
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                ECSlidingViewController *slider=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SlidingView"];
                HomePageViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"HomePage"];
                NavigationViewController *nav = [[storyboard instantiateViewControllerWithIdentifier:@"NavigationViewController"]initWithRootViewController:controller];
                [slider setTopViewController:nav];
                [slider resetTopViewAnimated:YES];
                [self.navigationController pushViewController:slider animated:YES];
            }
            
        }
        
    }
}
-(void) checkStepNumberForSetupWithAPI:(NSString *)apiName {
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            apiCount++;
            if (contentView) {
                [contentView removeFromSuperview];
            }
            contentView = [Utility activityIndicatorView:self];
            contentView.backgroundColor = [UIColor clearColor];
        });
        
        NSURLSession *customSession = [NSURLSession sharedSession];
        
        NSError *error;
        
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"UserID"] forKey:@"UserID"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:apiName append:@""forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[customSession dataTaskWithRequest:request
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
                                                                          [defaults setInteger:[[responseDict objectForKey:@"StepNumber"] intValue] forKey:@"CustomExerciseStepNumber"];
                                                                          switch ([[responseDict objectForKey:@"StepNumber"] intValue]) {
                                                                                  
                                                                              case -1:
                                                                                  //api call
                                                                                  [self checkStepNumberForSetupWithAPI:@"CheckUserProgramStep"];
                                                                                  break;
                                                                                  
                                                                              default:
                                                                                  exerciseSettingStepNumber = [[responseDict objectForKey:@"StepNumber"] intValue];
                                                                                  [self checkStepComplete];
                                                                                  break;
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
-(void)webSerViceCall_SquadNutritionSettingStep{
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            apiCount++;
            if (contentView) {
                [contentView removeFromSuperview];
            }
            contentView = [Utility activityIndicatorView:self];
            contentView.backgroundColor = [UIColor clearColor];
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
                                                                         nutritionSettingStepNumber=[[responseDict objectForKey:@"StepNumber"]intValue];
                                                                         [self checkStepComplete];
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
