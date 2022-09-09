//
//  CustomExerciseSettingsViewController.m
//  Squad
//
//  Created by AQB SOLUTIONS on 05/04/2017.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import "CustomExerciseSettingsViewController.h"
#import "CustomExerciseSettingsTableViewCell.h"
#import "Utility.h"
#import "RateFitnessLevelViewController.h"
#import "PersonalSessionsViewController.h"
#import "MovePersonalSessionViewController.h"
#import "ChooseGoalViewController.h"
#import "ViewPersonalSessionViewController.h"
#import "CustomProgramSetupViewController.h"
#import "GratitudeListViewController.h"

@interface CustomExerciseSettingsViewController () {
    IBOutlet NSLayoutConstraint *footerConstant;
    IBOutlet UIButton *menuButton;
    IBOutlet UITableView *table;
    IBOutlet NSLayoutConstraint *tableHeightConstraint;
    IBOutlet UIButton *redoButton;
    IBOutlet UIButton *resetButton;
    IBOutlet UIButton *backButton;
    
    NSArray *dataArray;
    UIView *contentView;
    int step;
}

@end

@implementation CustomExerciseSettingsViewController
//ah cpn

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@",self.navigationController.viewControllers);
    //if([[self.navigationController.viewControllers firstObject] isKindOfClass:[TrailHomeViewController class]]){
    if(![Utility isSubscribedUser]){
        menuButton.hidden = true;
        footerConstant.constant = 0;
    }else{
        menuButton.hidden = false;
        footerConstant.constant = 75;
    }
    redoButton.layer.cornerRadius = 5;
    resetButton.layer.cornerRadius = 5;
    redoButton.clipsToBounds = YES;
    resetButton.clipsToBounds = YES;
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    [backButton setImage:[[UIImage imageNamed:@"active_arrow.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [backButton setTintColor:[UIColor whiteColor]];
    dataArray = [[NSArray alloc] init];
    dataArray = @[@"Your Basic Info",@"Your Goal",@"Your Fitness Level",@"Equipment",@"Weekly Session Commitment",@"Personal Sessions",@"Weekly Schedule"];
    
    [self checkStepNumberForSetupWithAPI:@"CheckStepNumberForSetup"];
}

-(void) viewDidLayoutSubviews {
    tableHeightConstraint.constant = table.contentSize.height;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - IBAction
-(IBAction)homeButtonPressed:(UIButton*)sender{
//    TodayHomeViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"TodayHome"];
    GratitudeListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"GratitudeListView"];
    [self.navigationController pushViewController:controller animated:YES];
//    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)menuButtonPressed:(id)sender {
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
    [self.slidingViewController resetTopViewAnimated:YES];
}

-(IBAction)backButtonPressed:(id)sender{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"ViewPersonalUpdateView" object:self];
     [self.navigationController popViewControllerAnimated:YES];
//    NSArray *arr = self.parentViewController.navigationController.viewControllers;
//    UIViewController *controller = [self.parentViewController.navigationController.viewControllers objectAtIndex:arr.count-1];
//    if(![Utility isEmptyCheck:controller]){
//        if ([controller isKindOfClass:[ECSlidingViewController class]]) {
//            [self.slidingViewController anchorTopViewToLeftAnimated:YES];
//            [self.slidingViewController resetTopViewAnimated:YES];
//        }else{
//            [self.navigationController popToViewController:self animated:NO];
//        }
//    }else{
//        [self.slidingViewController anchorTopViewToLeftAnimated:YES];
//        [self.slidingViewController resetTopViewAnimated:YES];
//    }
    
}
- (IBAction)infoButtonPressed:(UIButton *)sender {//feedback info button
    NSString *urlString=@"https://player.vimeo.com/external/290408148.m3u8?s=c3ad46d97bf7a8aeb178919f3c9f29f10963340b";
    [Utility showHelpAlertWithURL:urlString controller:self haveToPop:NO];
}
-(IBAction)redoButtonTapped:(id)sender {
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Comfirm Redo"
                                          message:@"Do you want to redo your entire setting?"
                                          preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:@"Redo"
                               style:UIAlertActionStyleDestructive
                               handler:^(UIAlertAction *action)
                               {
                                   [self updatedUserProgramSetupStep];
                               }];
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:@"Cancel"
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {
                                       
                                   }];
    [alertController addAction:okAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
-(IBAction)resetButtonTapped:(id)sender {
    [self resetExerciseApiCall];
}
#pragma mark - API Calls
-(void) checkStepNumberForSetupWithAPI:(NSString *)apiName {
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
                                                                  if (contentView) {
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
                                                                                  step = [[responseDict objectForKey:@"StepNumber"] intValue];
                                                                                  [table reloadData];
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
-(void) resetExerciseApiCall {
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
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"ResetExercisePlanForCurrentWeek" append:@""forAction:@"POST"];
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
                                                                          switch (step) {
                                                                                  
                                                                              case 0:
                                                                              {
                                                                                  //current week
                                                                                  //if([[self.navigationController.viewControllers firstObject] isKindOfClass:[TrailHomeViewController class]]){
                                                                                  if(![Utility isSubscribedUser]){
                                                                                      [self.navigationController popToRootViewControllerAnimated:YES];
                                                                                  }else{
                                                                                      ViewPersonalSessionViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ViewPersonalSession"];
                                                                                      [self.navigationController pushViewController:controller animated:YES];
                                                                                  }
                                                                                  break;
                                                                              }
                                                                                  
                                                                              case 1:
                                                                              {
                                                                                  CustomProgramSetupViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CustomProgramSetup"];
                                                                                  [self.navigationController pushViewController:controller animated:YES];
                                                                                  break;
                                                                              }
                                                                                  
                                                                              case 2:
                                                                              {
                                                                                  ChooseGoalViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ChooseGoal"];
                                                                                  [self.navigationController pushViewController:controller animated:YES];
                                                                                  break;
                                                                              }
                                                                                  
                                                                              case 3:
                                                                              {
                                                                                  RateFitnessLevelViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"RateFitnessLevel"];
                                                                                  controller.isRateFitness = true;
                                                                                  controller.isWeeklySession = false;
                                                                                  [self.navigationController pushViewController:controller animated:YES];
                                                                                  break;
                                                                              }
                                                                                  
                                                                              case 4:
                                                                              {
                                                                                  RateFitnessLevelViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"RateFitnessLevel"];
                                                                                  controller.isRateFitness = false;
                                                                                  controller.isWeeklySession = false;
                                                                                  [self.navigationController pushViewController:controller animated:YES];
                                                                                  break;
                                                                              }
                                                                                  
                                                                              case 5:
                                                                              {
                                                                                  RateFitnessLevelViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"RateFitnessLevel"];
                                                                                  controller.isRateFitness = false;
                                                                                  controller.isWeeklySession = true;
                                                                                  [self.navigationController pushViewController:controller animated:YES];
                                                                                  break;
                                                                              }
                                                                                  
                                                                              case 6:
                                                                              {
                                                                                  PersonalSessionsViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PersonalSessions"];
                                                                                  [self.navigationController pushViewController:controller animated:YES];
                                                                                  break;
                                                                              }
                                                                                  
                                                                              case 7:
                                                                              {
                                                                                  MovePersonalSessionViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MovePersonalSession"];
                                                                                  [self.navigationController pushViewController:controller animated:YES];
                                                                                  break;
                                                                              }
                                                                                  
                                                                              default:
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

-(void) updatedUserProgramSetupStep {
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
        [mainDict setObject:[NSNumber numberWithInteger:1] forKey:@"StepNumber"];
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
                                                                          step = 1;
                                                                          [table reloadData];
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
#pragma mark - TableView Datasource & Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return dataArray.count;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0, tableView.frame.size.width, tableView.sectionFooterHeight)];
    view.backgroundColor = [UIColor whiteColor];
    return view;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *CellIdentifier =@"CustomExerciseSettingsTableViewCell";
    CustomExerciseSettingsTableViewCell *cell = (CustomExerciseSettingsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // Configure the cell...
    if (cell == nil) {
        cell = [[CustomExerciseSettingsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.stepNameLabel.text = [dataArray objectAtIndex:indexPath.row];
    cell.indexlabel.text = [@"" stringByAppendingFormat:@"%d",(int)indexPath.row+1];
    if (step > indexPath.row || step == 0) {
        cell.stepNameLabel.textColor = [Utility colorWithHexString:@"58595b"];
    } else {
        cell.stepNameLabel.textColor = [Utility colorWithHexString:@"b3aeae"];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (step > indexPath.row || step == 0) {
        switch (indexPath.row+1) {
            case 1:
            {
                CustomProgramSetupViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CustomProgramSetup"];
                [self.navigationController pushViewController:controller animated:YES];
                break;
            }
                
            case 2:
            {
                ChooseGoalViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ChooseGoal"];
                [self.navigationController pushViewController:controller animated:YES];
                break;
            }
                
            case 3:
            {
                RateFitnessLevelViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"RateFitnessLevel"];
                controller.isRateFitness = true;
                controller.isWeeklySession = false;
                [self.navigationController pushViewController:controller animated:YES];
                break;
            }
                
            case 4:
            {
                RateFitnessLevelViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"RateFitnessLevel"];
                controller.isRateFitness = false;
                controller.isWeeklySession = false;
                [self.navigationController pushViewController:controller animated:YES];
                break;
            }
                
            case 5:
            {
                RateFitnessLevelViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"RateFitnessLevel"];
                controller.isRateFitness = false;
                controller.isWeeklySession = true;
                [self.navigationController pushViewController:controller animated:YES];
                break;
            }
                
            case 6:
            {
                PersonalSessionsViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PersonalSessions"];
                [self.navigationController pushViewController:controller animated:YES];
                break;
            }
                
            case 7:
            {
                MovePersonalSessionViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MovePersonalSession"];
                [self.navigationController pushViewController:controller animated:YES];
                break;
            }
                
            default:
                break;
        }
    }
}
@end
