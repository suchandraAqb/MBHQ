//
//  NutritionSettingHomeViewController.m
//  Squad
//
//  Created by AQB Solutions-Mac Mini 2 on 27/03/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import "NutritionSettingHomeViewController.h"
#import "NutritionSettingsTableViewCell.h"
#import "MasterMenuViewController.h"
#import "ChooseGoalViewController.h"
#import "DietaryPreferenceViewController.h"
#import "MealVarietyViewController.h"
#import "MealFrequencyViewController.h"
#import "MealPlanViewController.h"
#import "TrailHomeViewController.h"
#import "LoginController.h"
#import "GratitudeListViewController.h"

@interface NutritionSettingHomeViewController ()
{
    IBOutlet NSLayoutConstraint *footerConstant;
    IBOutlet UIButton *menuButton;
    IBOutlet UITableView *nutritionSettingstable;
    NSMutableArray *nutritionSettingsArray;
    UIView *contentView;
    int stepnumber;
    BOOL isFromRedo;
    IBOutlet NSLayoutConstraint *redoButtonHeightConstant;
    IBOutlet UIButton *redoButton;
    IBOutlet UIButton *backButton;

}
@end

@implementation NutritionSettingHomeViewController

#pragma mark - IBAction
- (IBAction)menuTapped:(id)sender {
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
    [self.slidingViewController resetTopViewAnimated:YES];
}

-(IBAction)redoYourEntirePlan:(id)sender{
    isFromRedo = true;
    [defaults setObject:[NSNumber numberWithBool:isFromRedo] forKey:@"IsRedoDone"];
    [self webSerViceCall_UpdateNutrationStep];
}

- (IBAction)logoTapped:(id)sender {
//    TodayHomeViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"TodayHome"];
    GratitudeListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"GratitudeListView"];
    [self.navigationController pushViewController:controller animated:YES];
    
//    [self.navigationController  popToRootViewControllerAnimated:YES];
}
- (IBAction)infoButtonPressed:(UIButton *)sender {//feedback info button
    NSString *urlString=@"https://player.vimeo.com/external/290408304.m3u8?s=30a065fd81f71422918b1f4319cb291a96143850";
    [Utility showHelpAlertWithURL:urlString controller:self haveToPop:NO];
}
-(IBAction)backButtonPressed:(id)sender{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"NutritionSettingsUpdate" object:self];
     [self.navigationController popViewControllerAnimated:YES];
//    NSArray *arr = self.parentViewController.navigationController.viewControllers;
//    UIViewController *controller = [self.parentViewController.navigationController.viewControllers objectAtIndex:arr.count-1];
//    if(![Utility isEmptyCheck:controller]){
//        if ([controller isKindOfClass:[ECSlidingViewController class]]) {
//
//            [self.navigationController popToRootViewControllerAnimated:NO];
//        }else{
//            [self.navigationController popToViewController:self animated:NO];
//        }
//    }else{
//        [self.slidingViewController anchorTopViewToLeftAnimated:YES];
//        [self.slidingViewController resetTopViewAnimated:YES];
//    }
    
}
#pragma mark - End

#pragma mark - Private Function
-(void)webSerViceCall_UpdateNutrationStep{
     if (stepnumber != 0 || isFromRedo) {// < stepNumber) {
        if (Utility.reachable) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (contentView) {
                    [contentView removeFromSuperview];
                }
                contentView = [Utility activityIndicatorView:self];
            });
            
            stepnumber = 1;
            NSURLSession *loginSession = [NSURLSession sharedSession];
            NSError *error;
            NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
            
            [mainDict setObject:[defaults objectForKey:@"UserID"] forKey:@"UserID"];
            [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
            
            [mainDict setObject:[NSNumber numberWithInteger:stepnumber] forKey:@"StepNumber"];
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
                                                                             [defaults setObject:nil forKey:@"selectedMealName"];
                                                                             isFromRedo = false;
                                                                             [self webSerViceCall_SquadNutritionSettingStep];
                                                                             [nutritionSettingstable reloadData];
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
                                                                         if(stepnumber == 0){
                                                                            [defaults setObject:[NSNumber numberWithBool:true] forKey:@"IsAllStepComplete"];
                                                                         }
                                                                         if (stepnumber ==-1) {
                                                                             [self webSerViceCall_UpdateNutrationStep];
                                                                         }
                                                                         [nutritionSettingstable reloadData];
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

#pragma mark - View Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    nutritionSettingsArray = [[NSMutableArray alloc]initWithObjects:@"Your Goal",@"Dietery Preferences",@"Meal Frequency",@"Meal Variety",@"Meal Plan - Yet to select", nil];
    //if([[self.navigationController.viewControllers firstObject] isKindOfClass:[TrailHomeViewController class]]){
    if(![Utility isSubscribedUser]){
        menuButton.hidden = true;
        footerConstant.constant = 0;
    }else{
        menuButton.hidden = false;
        footerConstant.constant = 75;
    }
    [defaults setObject:[NSNumber numberWithBool:false] forKey:@"IsRedoDone"];
 }

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    stepnumber=0;
    [backButton setImage:[[UIImage imageNamed:@"active_arrow.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [backButton setTintColor:[UIColor whiteColor]];
    [self webSerViceCall_SquadNutritionSettingStep];
    //For dev1
 //  stepnumber=-12345;
 //  [nutritionSettingstable reloadData];

}

#pragma mark - End

#pragma mark - Memory Warning

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView DataSource & Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return nutritionSettingsArray.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0, tableView.frame.size.width, tableView.sectionFooterHeight)];
    view.backgroundColor = [UIColor whiteColor];
    return view;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *CellIdentifier =@"NutritionSettingsTableViewCell";
    NutritionSettingsTableViewCell *cell = (NutritionSettingsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // Configure the cell...
    if (cell == nil) {
        cell = [[NutritionSettingsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if (indexPath.row == 4) {
         NSString *newStr =@"";
        if (![Utility isEmptyCheck:[defaults objectForKey:@"selectedMealName"]]) {
            NSArray *items = [[nutritionSettingsArray objectAtIndex:indexPath.row] componentsSeparatedByString:@"-"];
            NSString *str1=[[items objectAtIndex:0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            NSString *str2=[[items objectAtIndex:1]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            if (![Utility isEmptyCheck:str2] ) {
                str2=[defaults objectForKey:@"selectedMealName"];
            }
                newStr =[[@"" stringByAppendingFormat:@"%@ - %@",str1,str2]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            }else{
                newStr =@"Meal Plan - Yet to select";
            }
            [nutritionSettingsArray replaceObjectAtIndex:4 withObject:newStr];
    }
    cell.settingsLabel.text = [nutritionSettingsArray objectAtIndex:indexPath.row];
    cell.indexLabel.text =[@"" stringByAppendingFormat:@"%ld",indexPath.row +1];
    cell.userInteractionEnabled=false;
    
//    if (indexPath.row == 0 && (stepnumber == 0 || stepnumber == 1 || stepnumber<0)) {
//        cell.userInteractionEnabled=true;
//    }else if (indexPath.row+1<=stepnumber && stepnumber>1){
//        cell.userInteractionEnabled=true;
//        cell.settingsLabel.textColor=[Utility colorWithHexString:@"f427ab"];
//        cell.indexLabel.textColor=[UIColor whiteColor];
//    }
//    else{
//        cell.settingsLabel.textColor=[UIColor grayColor];
//        cell.indexLabel.textColor=[UIColor grayColor];
//        cell.userInteractionEnabled=false;
//    }
    
    if (indexPath.row == 0 && (stepnumber == 1 || stepnumber<0)) {
        cell.userInteractionEnabled=true;
    }else if (indexPath.row+1<=stepnumber || stepnumber==0){
        cell.userInteractionEnabled=true;
        cell.settingsLabel.textColor=[Utility colorWithHexString:@"58595b"];
        cell.indexLabel.textColor=[Utility colorWithHexString:@"E425A0"];
    }
    else{
        cell.settingsLabel.textColor=[UIColor grayColor];
        cell.indexLabel.textColor=[UIColor grayColor];
        cell.userInteractionEnabled=false;
    }

        return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        ChooseGoalViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ChooseGoal"];
        controller.isNutritionSettings=true;
        [self.navigationController pushViewController:controller animated:YES];
    }
   else if (indexPath.row == 1) {
        DietaryPreferenceViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DietaryPreferenceView"];
        [self.navigationController pushViewController:controller animated:YES];

    }
   else if (indexPath.row == 2) {
        MealFrequencyViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MealFrequencyView"];
        [self.navigationController pushViewController:controller animated:YES];
        
    }
    else if (indexPath.row == 3) {
        MealVarietyViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MealVarietyView"];
        [self.navigationController pushViewController:controller animated:YES];
        
    }
    else if (indexPath.row == 4) {
        MealPlanViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MealPlanView"];
        [self.navigationController pushViewController:controller animated:YES];
        
    }
    
}



@end
