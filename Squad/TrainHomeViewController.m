//
//  TrainHomeViewController.m
//  Squad
//
//  Created by AQB Mac 4 on 15/12/16.
//  Copyright © 2016 AQB Solutions. All rights reserved.
//

#import "TrainHomeViewController.h"
#import "ChalengesHomeViewController.h"
//#import "MyExercisePlanViewController.h"
#import "ExerciseDailyListViewController.h"
#import "CustomProgramSetupViewController.h"
#import "ExerciseListViewController.h"
#import "ExerciseDetailsViewController.h"
#import "CircuitListViewController.h"
#import "SessionListViewController.h"
//ah cpn
#import "Utility.h"
#import "RateFitnessLevelViewController.h"
#import "PersonalSessionsViewController.h"
#import "MovePersonalSessionViewController.h"
#import "ChooseGoalViewController.h"
#import "ViewPersonalSessionViewController.h"
#import "FBWHomeViewController.h"
#import "AudioBookViewController.h"
#import "CoursesListViewController.h"
#import "WebinarListViewController.h"

#import "DietaryPreferenceViewController.h"
#import "RoundListViewController.h"

@interface TrainHomeViewController (){
    UIView *contentView;
    //Chayan
    IBOutlet UIButton *helpButton;
    IBOutletCollection(UIButton) NSArray *actionButtons;
    //ah fbw(storyboard also)
    IBOutlet UIButton *fbwButton;
    NSArray *dataArray;
    IBOutlet UITableView *trainTable;
    IBOutlet UIView *headerContainerView;
    IBOutlet UIView *challengeContainerView;
    int stepnumber;  //Change_26032018
    
    IBOutletCollection(UIView) NSArray *viewsNeedToRestrict;
    
    __weak IBOutlet UIStackView *otherListsStackView;
    
    __weak IBOutlet UIView *blankView;
    BOOL isFirstLoad;
}

@end

@implementation TrainHomeViewController
@synthesize haveToSendToExerciseSettings,fromTodayPage;
#pragma mark - View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    isFirstLoad = true;
    if (fromTodayPage) {
        blankView.hidden = false;
    }else{
        blankView.hidden = true;
    }
    blankView.hidden = false;
    if ([Utility isSubscribedUser]) {
        challengeContainerView.alpha = 1.0f;
    }else{
        challengeContainerView.alpha = 0.5f;
    }
    dataArray = @[
                  @{
                      @"title" : @"ACTIVITY TRACKER",
                      @"details" : @[
                              @"FITBIT/IWATCH",
                              @"FBW TRACKER",
                              @"AUDIOBOOKS",
                              @"WEBINARS",
                              @"COURSES"
                          ],
                      },
                  @{
                      @"title" : @"TRAINING LISTS",
                      @"details" : @[
                              @"EXERCISE LIST",
                              @"SESSION LIST"
                              ],
                      }
                  ];
    if (haveToSendToExerciseSettings) { //Change_26032018
        if ([[defaults objectForKey:@"SendToCustomPlan"] isEqualToString:@"Exercise"]) {
            [self checkStepNumberForSetupWithAPI:@"CheckUserProgramStep"];
        }else{
            [self webSerViceCall_SquadNutritionSettingStep]; //Change_26032018
        }
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    if(!isFirstLoad && _redirectBackToTodayPage){
        [self.navigationController popViewControllerAnimated:NO];
        return;
    }
    
    NSError *sessionError = nil;
    @try {
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient   error:&sessionError];
        [[AVAudioSession sharedInstance] setActive:YES error:nil];
        [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
        
    } @catch (NSException *exception) {
        NSLog(@"Audio Session error %@, %@", exception.reason, exception.userInfo);
        
    } @finally {
        NSLog(@"Audio Session finally");
    }
    
    BOOL isLiteUser = [Utility isSquadLiteUser];
    BOOL isFreeUser = [Utility isSquadFreeUser];
    
    for(UIView *view in viewsNeedToRestrict){
        if(isLiteUser || isFreeUser)    {
            NSLog(@"Hint-- %@",view.accessibilityHint);
            if([view.accessibilityHint isEqualToString:@"dailyworkout"] || [view.accessibilityHint isEqualToString:@"sessionList"] || [view.accessibilityHint isEqualToString:@"circuitTimer"]){
                view.alpha = 1.0;
            }else{
                if((isLiteUser || isFreeUser) && [view.accessibilityHint isEqualToString:@"fitbit"]){
                    view.alpha = 1.0;
                }else{
                    view.alpha = 0.5;
                }
            }
            
        }else{
            view.alpha = 1.0;
        }
    }
    
    /*if(isFreeUser){
        challengeContainerView.hidden = true;
        otherListsStackView.hidden = true;
    }else{
        challengeContainerView.hidden = false;
        otherListsStackView.hidden = false;
    }*/
    
    
    
}

//chayan
-(void) viewDidAppear:(BOOL)animated {  //ah ux
    [super viewDidAppear:YES];
    if ([[defaults objectForKey:@"firstTimeHelpDict"] valueForKey:@"isFirstTimeTrain"]) {
        [self animateHelp];
    }
    
//    if(!_redirectBackToTodayPage){
//        if (![Utility isEmptyCheck:[defaults objectForKey:@"InstructionOverlays"]]){
//            NSMutableArray *insArray = [[NSMutableArray alloc] initWithArray:[defaults objectForKey:@"InstructionOverlays"]];
//            if (![insArray containsObject:@"Train"]) {
//                //[self helpButtonPressed:helpButton];
//                [self showInstructionOverlays];
//                [insArray addObject:@"Train"];
//                [defaults setObject:insArray forKey:@"InstructionOverlays"];
//            }
//        }else {
//            //[self helpButtonPressed:helpButton];
//            [self showInstructionOverlays];
//            NSMutableArray *insArray = [[NSMutableArray alloc] init];
//            [insArray addObject:@"Train"];
//            [defaults setObject:insArray forKey:@"InstructionOverlays"];
//        }
//    }
    
    
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
//    blankView.hidden = true;
    fromTodayPage = false;
    isFirstLoad = NO;
}
#pragma mark - End

#pragma mark - IBAction
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
    
    NSString *urlString=@"https://player.vimeo.com/external/220932728.m3u8?s=5df94fedbc4655abb941380001975b0f4665586c";
    
    if ([[[defaults objectForKey:@"firstTimeHelpDict"] valueForKey:@"isFirstTimeTrain"] boolValue]) {
        [Utility showHelpAlertWithURL:urlString controller:self haveToPop:YES];
        NSMutableDictionary *dict=[[defaults objectForKey:@"firstTimeHelpDict"] mutableCopy];
        [dict setObject:[NSNumber numberWithBool:NO] forKey:@"isFirstTimeTrain"];
        [defaults setObject:dict forKey:@"firstTimeHelpDict"];
    }
    else{
        [Utility showHelpAlertWithURL:urlString controller:self haveToPop:NO];
    }

}




- (IBAction)itemButtonPressed:(UIButton *)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSError *sessionError = nil;
        @try {
            [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient   error:&sessionError];
            [[AVAudioSession sharedInstance] setActive:YES error:nil];
            [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
            
        } @catch (NSException *exception) {
            NSLog(@"Audio Session error %@, %@", exception.reason, exception.userInfo);
            
        } @finally {
            NSLog(@"Audio Session finally");
        }
        if(sender.tag == 0){
            ExerciseDailyListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ExerciseDailyList"];
            [self.navigationController pushViewController:controller animated:YES];
            //ExerciseDetailsViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ExerciseDetails"];
            //[self.navigationController pushViewController:controller animated:YES];
            
        }else if(sender.tag == 1){
            
            if([Utility isSquadLiteUser]){
                [Utility showSubscribedAlert:self];
                return;
            }else if([Utility isSquadFreeUser]){
                [Utility showAlertAfterSevenDayTrail:self];
                return;
            }
            
            if (![Utility isSubscribedUser] && ![defaults boolForKey:@"IsNonSubscribedUser"]){
                [Utility showTrailLoginAlert:self ofType:self];
                return;
            }
            int currentStep = [[defaults objectForKey:@"CustomExerciseStepNumber"] intValue];
            
            if([Utility isSubscribedUser] && [Utility isOfflineMode]){
                
                if(currentStep == 0){
                    ViewPersonalSessionViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ViewPersonalSession"];
                    [self.navigationController pushViewController:controller animated:YES];
                }else{
                    [Utility msg:@"Please go online and complete required steps to access this feature." title:@"Oops! " controller:self haveToPop:NO];
                }
                
            }else{
                [self checkStepNumberForSetupWithAPI:@"CheckStepNumberForSetup"];
            }//AY 06032018
            
            //            CustomProgramSetupViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CustomProgramSetup"];
            //            [self.navigationController pushViewController:controller animated:YES];
            //            [Utility msg:@"Coming Soon." title:@"Alert" controller:self haveToPop:NO];
        }else if(sender.tag == 2){
            
            if([Utility isSquadLiteUser]){
                [Utility showSubscribedAlert:self];
                return;
            }else if([Utility isSquadFreeUser]){
                [Utility showAlertAfterSevenDayTrail:self];
                return;
            }
            if([Utility isSubscribedUser] && [Utility isOfflineMode]){
                [self checkOfflineAccess];
                return;
            }

            if([Utility isSubscribedUser]){
                ChalengesHomeViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ChalengesHome"];
                [self.navigationController pushViewController:controller animated:YES];
            }else{
                [Utility showSubscribedAlert:self];
            }
        }else if(sender.tag == 3){
            
            if([Utility isSquadLiteUser]){
                [Utility showSubscribedAlert:self];
                return;
            }else if([Utility isSquadFreeUser]){
                [Utility showAlertAfterSevenDayTrail:self];
                return;
            }
            if([Utility isSubscribedUser] && [Utility isOfflineMode]){
                [self checkOfflineAccess];
                return;
            }
            ExerciseListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ExerciseList"];
            [self.navigationController pushViewController:controller animated:YES];
        }else if(sender.tag == 4){
            
            if([Utility isSquadLiteUser]){
                [Utility showSubscribedAlert:self];
                return;
            }else if([Utility isSquadFreeUser]){
                [Utility showAlertAfterSevenDayTrail:self];
                return;
            }
            if([Utility isSubscribedUser] && [Utility isOfflineMode]){
                [self checkOfflineAccess];
                return;
            }
            
            CircuitListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CircuitList"];
            [self.navigationController pushViewController:controller animated:YES];
        }else if(sender.tag == 5){
            if([Utility isSquadLiteUser]){
                [Utility showSubscribedAlert:self];
                return;
            }else if([Utility isSquadFreeUser]){
//                [Utility showAlertAfterSevenDayTrail:self];
//                return;
            }
            if([Utility isSubscribedUser] && [Utility isOfflineMode]){
                [self checkOfflineAccess];
                return;
            }
            //            AdvanceSearchForSessionViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AdvanceSearchForSessionViewController"];
            //            [self.navigationController pushViewController:controller animated:YES];
            SessionListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SessionList"];
            [self.navigationController pushViewController:controller animated:NO];
        } else if (sender.tag == 6) {       //ah fbw
           
        }else if(sender.tag == 7){
           
        }else if(sender.tag == 8){
            if([Utility isSquadLiteUser]){
                [Utility showSubscribedAlert:self];
                return;
            }else if([Utility isSquadFreeUser]){
                [Utility showAlertAfterSevenDayTrail:self];
                return;
            }
            if([Utility isSubscribedUser] && [Utility isOfflineMode]){
                [self checkOfflineAccess];
                return;
            }
            AudioBookViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AudioBook"];
            [self.navigationController pushViewController:controller animated:YES];
        }else if(sender.tag == 9){
            if([Utility isSquadLiteUser]){
                [Utility showSubscribedAlert:self];
                return;
            }else if([Utility isSquadFreeUser]){
                [Utility showAlertAfterSevenDayTrail:self];
                return;
            }
            if([Utility isSubscribedUser] && [Utility isOfflineMode]){
                [self checkOfflineAccess];
                return;
            }
            WebinarListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"WebinarListView"];
            [self.navigationController pushViewController:controller animated:YES];
        }else if(sender.tag == 10){
            if([Utility isSquadLiteUser]){
                [Utility showSubscribedAlert:self];
                return;
            }else if([Utility isSquadFreeUser]){
                [Utility showAlertAfterSevenDayTrail:self];
                return;
            }
            if([Utility isSubscribedUser] && [Utility isOfflineMode]){
                [self checkOfflineAccess];
                return;
            }
            CoursesListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CoursesList"];
            [self.navigationController pushViewController:controller animated:YES];
        }else if(sender.tag == 11){
            if([Utility isSquadFreeUser]){
//                [Utility showAlertAfterSevenDayTrail:self];
//                return;
            }
            if([Utility isSubscribedUser] && [Utility isOfflineMode]){
                [self checkOfflineAccess];
                return;
            }
           
        }
        else if(sender.tag == 12){
            
            RoundListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"RoundList"];
            [self.navigationController pushViewController:controller animated:YES];
        }
    });
    
}

#pragma mark - End

#pragma mark - API Calls
-(void) checkStepNumberForSetupWithAPI:(NSString *)apiName {
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
            self->contentView = [Utility activityIndicatorView:self];
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
                                                                  if (self->contentView) {
                                                                      [self->contentView removeFromSuperview];
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
                                                                                  
                                                                              case 0:
                                                                              {
                                                                                  //current week
                                                                                  //current week
                                                                                  //if([[self.navigationController.viewControllers firstObject] isKindOfClass:[TrailHomeViewController class]]){
//                                                                                  if([defaults boolForKey:@"IsNonSubscribedUser"]){
//                                                                                      [self.navigationController popToRootViewControllerAnimated:YES];
//                                                                                  }else{
//
//                                                                                  }
                                                                                  ViewPersonalSessionViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ViewPersonalSession"];
                                                                                  [self.navigationController pushViewController:controller animated:YES];
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

-(void)webSerViceCall_SquadNutritionSettingStep{
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
                                                                 if (self->contentView) {
                                                                     [self->contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"SuccessFlag"]boolValue]) {
                                                                         self->stepnumber=[[responseDict objectForKey:@"StepNumber"]intValue];
                                                                         if (!(self->stepnumber == 0)) {
                                                                             [self webSerViceCall_UpdateNutrationStep];
                                                                         }else{
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

-(void)webSerViceCall_UpdateNutrationStep{
    if (stepnumber != 0) {// < stepNumber) {
        if (Utility.reachable) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self->contentView) {
                    [self->contentView removeFromSuperview];
                }
                self->contentView = [Utility activityIndicatorView:self];
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
                                                                     if (self->contentView) {
                                                                         [self->contentView removeFromSuperview];
                                                                     }
                                                                     if(error == nil)
                                                                     {
                                                                         NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                         NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                         if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"]boolValue]) {
                                                                             [defaults setObject:nil forKey:@"selectedMealName"];
                                                                             DietaryPreferenceViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DietaryPreferenceView"];
                                                                             [self.navigationController pushViewController:controller animated:YES];
                                                                             
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
} //Change_26032018
#pragma mark - Private Method

//chayan
-(void) animateHelp {   //ah ux
    [UIView animateWithDuration:1.5 animations:^{
        self->helpButton.alpha = 0.2;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1.5 animations:^{
            self->helpButton.alpha = 1;
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
                          @"insText" :  @"Click here for tools and tips to get the most out of the TRAIN section.",
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
-(void)checkOfflineAccess{
    [Utility msg:@"You are in OFFLINE mode. Go Online to access this functionality." title:@"Oops!\n" controller:self haveToPop:NO];
}
//- (void) showInstructionOverlays {
//    NSMutableArray *overlayViews = [[NSMutableArray alloc] init];
//    NSArray *messageArray = @[
//                              @"Click here for tools and tips to get the most out of the TRAIN section."
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


@end
