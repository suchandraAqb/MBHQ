//
//  TrackViewController.m
//  Squad
//
//  Created by AQB Mac 4 on 19/12/16.
//  Copyright © 2016 AQB Solutions. All rights reserved.
//

#import "TrackViewController.h"
#import "WaterIntakeViewController.h"
#import "MyPhotosViewController.h"
#import "MyPhotosDefaultViewController.h"
#import "FBWHomeViewController.h"
#import "MealMatchViewController.h"
#import "DietaryPreferenceViewController.h"
#import "MealFrequencyViewController.h"
#import "MealVarietyViewController.h"
#import "MealPlanViewController.h"
#import "QuestionnaireHomeViewController.h"

//ah newt

//chayan : import
#import "Utility.h"

@interface TrackViewController (){
    //Chayan
    IBOutlet UIButton *helpButton;
    IBOutletCollection(UIButton) NSArray *actionButtons;
    IBOutlet UIView *headerContainerView;
    UIView *contentView;
    int apiCount;
    int stepnumber;
    NSDictionary *currprogram;
    __weak IBOutlet UIView *blankView;
    BOOL isFirstLoad;
}

@end

@implementation TrackViewController
@synthesize fromTodayPage;

- (void)viewDidLoad {
    [super viewDidLoad];
    isFirstLoad = YES;
    if (fromTodayPage) {
        blankView.hidden = false;
    }else{
        blankView.hidden = true;
    }
    blankView.hidden = false;
}

//chayan
-(void) viewDidAppear:(BOOL)animated {  //ah ux
    [super viewDidAppear:YES];
    
    
//    if(!_redirectBackToTodayPage){
//        
//        if ([[[defaults objectForKey:@"firstTimeHelpDict"] valueForKey:@"isFirstTimeTrack"] boolValue]) {
//            [self animateHelp];
//        }
//        
//        if (![Utility isEmptyCheck:[defaults objectForKey:@"InstructionOverlays"]]){
//            NSMutableArray *insArray = [[NSMutableArray alloc] initWithArray:[defaults objectForKey:@"InstructionOverlays"]];
//            if (![insArray containsObject:@"TRACK"]) {
//                //[self helpButtonPressed:helpButton];
//                [self showInstructionOverlays];
//                [insArray addObject:@"TRACK"];
//                [defaults setObject:insArray forKey:@"InstructionOverlays"];
//            }
//        }else {
//            //[self helpButtonPressed:helpButton];
//            [self showInstructionOverlays];
//            NSMutableArray *insArray = [[NSMutableArray alloc] init];
//            [insArray addObject:@"TRACK"];
//            [defaults setObject:insArray forKey:@"InstructionOverlays"];
//        }
//        
//    }
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(!isFirstLoad && _redirectBackToTodayPage){
        [self.navigationController popViewControllerAnimated:NO];
        return;
    }
    [self webSerViceCall_GetSquadCurrentProgram];
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
//    blankView.hidden = true;
    fromTodayPage = false;
    isFirstLoad = NO;
}
#pragma mark -IBAction
-(IBAction)itemButtonPressed:(UIButton *)sender{
    if (sender.tag == 0) {  //ah newt(main.storyboard too)
        MyPhotosDefaultViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MyPhotosDefault"];
        [self.navigationController pushViewController:controller animated:YES];
    }else if (sender.tag == 1) {
    }else if (sender.tag == 2) {

       
    }else if(sender.tag == 3){
       
    }else if(sender.tag == 4){
        WaterIntakeViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"WaterIntake"];
        [self.navigationController pushViewController:controller animated:YES];
    }
    else if(sender.tag == 5){
        FBWHomeViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"FBWHome"];
        [self.navigationController pushViewController:controller animated:YES];
    }
    else if(sender.tag == 6){
        [self checkNutritionStep:6];
//        MealMatchViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MealMatchView"];
//        [self.navigationController pushViewController:controller animated:YES];
    }else if(sender.tag == 7){
        
        QuestionnaireHomeViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"QuestionnaireHomeView"];
        [self.navigationController pushViewController:controller animated:YES];
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
    
    NSString *urlString=@"https://player.vimeo.com/external/220933540.m3u8?s=ea345fe4a29d1c3409a4b3b8f381ced8f99f2870";
    
    if ([[[defaults objectForKey:@"firstTimeHelpDict"] valueForKey:@"isFirstTimeTrack"] boolValue]) {
        [Utility showHelpAlertWithURL:urlString controller:self haveToPop:YES];
        NSMutableDictionary *dict=[[defaults objectForKey:@"firstTimeHelpDict"] mutableCopy];
        [dict setObject:[NSNumber numberWithBool:NO] forKey:@"isFirstTimeTrack"];
        [defaults setObject:dict forKey:@"firstTimeHelpDict"];
    }
    else{
        [Utility showHelpAlertWithURL:urlString controller:self haveToPop:NO];
    }
}



#pragma mark -End


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
- (void) showInstructionOverlays {
    NSMutableArray *overlayViews = [[NSMutableArray alloc] init];
    overlayViews = [@[@{
                          @"view" : headerContainerView,
                          @"onTop" : @NO,
                          @"insText" : @"Click here for tools and tips to get the most out of the TRACK section.",
                          @"isCustomFrame" : @true,
                          @"isFromHeader" :@true,
                          @"frame" : headerContainerView
                          },
                      ] mutableCopy];
    
    int multiplierX = 1;
    for (int i = 0; i < overlayViews.count; i++) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:overlayViews[i]];
        if ([[dict objectForKey:@"isCustomFrame"] boolValue]) {
            CGRect newFrame = headerContainerView.frame;
            CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
            newFrame.origin.x = (screenWidth/2.0)*multiplierX;//(screenWidth/5.0) +
            NSLog(@"%f",newFrame.origin.x);
            newFrame.size.width = (screenWidth/2.0);
            [dict setObject:[NSValue valueWithCGRect:newFrame] forKey:@"frame"];
            [overlayViews replaceObjectAtIndex:i withObject:dict];
            multiplierX++;
        }
    }
    [Utility initializeInstructionAt:self OnViews:overlayViews];
}
-(void)webSerViceCall_GetSquadCurrentProgram{
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
                                                                 self->apiCount--;
                                                                 if (self->contentView && self->apiCount == 0) {
                                                                     [self->contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"]boolValue]) {
                                                                         self->currprogram=[responseDict objectForKey:@"SquadProgram"];
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
            self->apiCount++;
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
                                                                 if (self->contentView && self->apiCount == 0) {
                                                                     [self->contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"SuccessFlag"]boolValue]) {
                                                                         self->stepnumber=[[responseDict objectForKey:@"StepNumber"]intValue];
                                                                         
                                                                         //ah ux
//                                                                         if (isFromNotification) {
//                                                                             isFromNotification=false;
//                                                                             [self checkNutritionStep:1];
//                                                                         }
//
//                                                                         if (_isFromMealMatchNotification) {
//                                                                             _isFromMealMatchNotification=false;
//                                                                             [self checkNutritionStep:4];
//                                                                         }//AY 21032018
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
        if(tag == 6){
            MealMatchViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MealMatchView"];
            [self.navigationController pushViewController:controller animated:YES];
        }
        
    }
}
//- (void) showInstructionOverlays {
//    NSMutableArray *overlayViews = [[NSMutableArray alloc] init];
//    NSArray *messageArray = @[
//                              @"Click here for tools and tips to get the most out of the TRACK section."
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
//        //        tempRect.cen
//        CGRect rect = CGRectMake(tempRect.origin.x, tempRect.origin.y-tempRect.size.height/2, tempRect.size.width, tempRect.size.height);
//        [dict setObject:[NSValue valueWithCGRect:rect] forKey:@"frame"];
//        [overlayViews addObject:dict];
//    }
//    [Utility initializeInstructionAt:self OnViews:overlayViews];
//}

#pragma mark - End


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
