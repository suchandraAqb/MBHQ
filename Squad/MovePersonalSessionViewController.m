//
//  MovePersonalSessionViewController.m
//  Squad
//
//  Created by AQB SOLUTIONS on 13/02/2017.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import "MovePersonalSessionViewController.h"
#import "MoveCollectionViewCell.h"
#import "MasterMenuViewController.h"
#import "ViewPersonalSessionViewController.h"
#import "MoveTableViewCell.h"
#import "PersonalSessionsViewController.h"
#import "CustomExerciseSettingsViewController.h"
#import "ViewPersonalSessionViewController.h"
#import "CustomExerciseSettingsViewController.h"
#import "DietaryPreferenceViewController.h"

@interface MovePersonalSessionViewController () {
    IBOutlet NSLayoutConstraint *footerConstant;
    IBOutlet UIButton *menuButton;//ahd
    IBOutlet UICollectionView *moveCollectionView;
    IBOutlet UILabel *header;
    IBOutlet UILabel *pageNumber;
    IBOutlet NSLayoutConstraint *moveColViewHeightConstraint;
    IBOutlet UIButton *cancelMoveButton;
    IBOutlet UIButton *exercisePlanButton;  //completeButton
    
    IBOutlet UIButton *nextForNonSubscribedUser;
    IBOutlet UITableView *firstTableView;
    IBOutlet UITableView *secondTableView;
    IBOutlet UITableView *thirdTableView;
    
    IBOutlet UIButton *nextButton;
    
    IBOutlet UIButton *backToExSettingsButton;
    IBOutlet NSLayoutConstraint *backExButtonHeightConstraint;
    
    IBOutlet NSLayoutConstraint *exercisePlanHeightConstraint;
    UIView *contentView;
    NSMutableArray *weekdays;
    NSMutableArray *responseObjArray;
    NSMutableDictionary *sessionTypeDict;
    NSMutableDictionary *bodyTypeDict;
    NSMutableDictionary *swapDict;
    
    int selectedIndex;
    int selectedTable;  //2 or 3
    int customProgramStep;
    int apiCount;
    
    NSMutableArray *sessionTypeArray;
    NSMutableDictionary *submitDict;
    int stepnumber;
    //20/06/18 Design chng
    __weak IBOutlet UIView *editView;
    __weak IBOutlet UIView *editInnerView;
    __weak IBOutlet UIButton *moveSwapButton;
    __weak IBOutlet UIButton *editSessionButton;
    __weak IBOutlet UIScrollView *mainScroll;
    UIImageView *triangleImageView;
    __weak IBOutlet NSLayoutConstraint *editViewTopConstraint;
    CGFloat cX,cY;
    __weak IBOutlet UIView *sessionView;
    __weak IBOutlet UILabel *newSessionTypeLabel;
    __weak IBOutlet UIStackView *sessionStackView;
    IBOutletCollection(UIButton) NSArray *weightGymButtonCollection;
    IBOutletCollection(UIButton) NSArray *weightGymOptionButtonCollection;
    IBOutletCollection(UIView) NSArray *weightViewCollection;
    IBOutletCollection(UILabel) NSArray *weightLabelCollection;
    NSMutableDictionary *bwDict;
    NSDictionary *currprogram;
}

@end
static NSIndexPath  *sourceIndexPath = nil;
@implementation MovePersonalSessionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    stepnumber = -120;
    //if([[self.navigationController.viewControllers firstObject] isKindOfClass:[TrailHomeViewController class]]){
    if(![Utility isSubscribedUser]){
        menuButton.hidden = true;
        footerConstant.constant = 0;
    }else{
        menuButton.hidden = false;
        footerConstant.constant = 75;
    }
    cancelMoveButton.hidden = YES;
    customProgramStep = -1;
    apiCount = 0;
    
    responseObjArray = [[NSMutableArray alloc]init];
    weekdays = [[NSMutableArray alloc]init];
    sessionTypeDict = [[NSMutableDictionary alloc]init];
    bodyTypeDict = [[NSMutableDictionary alloc]init];
    selectedIndex = -1;
    selectedTable = -1;
    swapDict = [[NSMutableDictionary alloc] init];
    sessionTypeArray = [[NSMutableArray alloc] init];
    submitDict = [[NSMutableDictionary alloc] init];
    
    //FeedBack_SB
    if(!([defaults integerForKey:@"CustomExerciseStepNumber"] == 0)){
        pageNumber.text = @"6 of 7";
    }else{
        pageNumber.text = @"7 of 7";
    }
    //FeedBack_SB
    header.text = @"Your weekly schedule is below. Please tap on a session name to move/swap any of the sessions and/or FBW’s to the days you prefer. \nOnce you are happy, click 'COMPLETE SETTINGS' to finalise your custom exercise program.";
    
    exercisePlanButton.layer.cornerRadius = 5;
    exercisePlanButton.clipsToBounds = YES;
    
    //    //if([[self.navigationController.viewControllers firstObject] isKindOfClass:[TrailHomeViewController class]] || [defaults boolForKey:@"IsNonSubscribedUser"]){
    if(![Utility isEmptyCheck:[defaults objectForKey:@"SendToCustomPlan"]]){
        backToExSettingsButton.hidden = true;
        backExButtonHeightConstraint.constant = 0;
        if ([defaults integerForKey:@"CustomExerciseStepNumber"] == 0) {
            nextForNonSubscribedUser.hidden = false;
        }else{
            nextForNonSubscribedUser.hidden = true;
        }
        exercisePlanHeightConstraint.constant = 0;
    }else{
        if ([defaults integerForKey:@"CustomExerciseStepNumber"] == 0) {
            nextForNonSubscribedUser.hidden = false;
            backToExSettingsButton.hidden=false;
            backExButtonHeightConstraint.constant = 40;
        }else {
            nextForNonSubscribedUser.hidden = true;
            backToExSettingsButton.hidden = true;
            backExButtonHeightConstraint.constant = 0;
        }
        exercisePlanHeightConstraint.constant = 35;
        
    }
    moveSwapButton.layer.borderWidth = 1;
    moveSwapButton.layer.borderColor = [UIColor whiteColor].CGColor;
    editSessionButton.layer.borderWidth = 1;
    editSessionButton.layer.borderColor = [UIColor whiteColor].CGColor;
    for (UIButton *btn in weightGymButtonCollection) {
        btn.layer.borderWidth = 1;
        btn.layer.borderColor = [UIColor colorWithRed:228/255.0f green:39/255.0f blue:160/255.0f alpha:1.0].CGColor;
    }
    for (UIButton *btn in weightGymOptionButtonCollection) {
        btn.layer.borderWidth = 1;
        btn.layer.borderColor = [UIColor colorWithRed:228/255.0f green:39/255.0f blue:160/255.0f alpha:1.0].CGColor;
    }
    editView.hidden = true;
    sessionView.hidden = true;
    
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    NSDateFormatter * df = [[NSDateFormatter alloc] init];
    [df setLocale: [NSLocale currentLocale]];
    weekdays = [[df weekdaySymbols] mutableCopy];
    [weekdays removeObjectAtIndex:0];
    [weekdays addObject:@"Sunday"];
    [firstTableView reloadData];
    NSLog(@"wds %@",weekdays);
}
-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    sessionTypeDict = [@{  @"1" : @"Weights",
                           @"2" : @"HIIT",
                           @"3" : @"Pilates",
                           @"4" : @"Yoga",
                           @"5" : @"Cardio",
                           @"6" : @"CardioBasedClass",
                           @"7" : @"ResistanceBasedClass",
                           @"8" : @"Sport",
                           @"9" : @"FBW",
                           @"11" : @"Other"
                           } mutableCopy];
    
    bodyTypeDict = [@{      @"0" : @"Other",
                            @"1" : @"FullBody",
                            @"2" : @"LowerBody",
                            @"3" : @"UpperBody",
                            @"4" : @"Core"} mutableCopy];
    
    sessionTypeArray = [@[
                          @{
                              @"name" : @"Move/Swap",
                              @"sessionTypeId" :   @0,
                              @"bodyTypeId" : @0,
                              @"isMaster" : @1,
                              @"haveAction": @1
                              },
                          @{
                              @"name" : @"Change session type",
                              @"sessionTypeId" :   @0,
                              @"bodyTypeId" : @0,
                              @"isMaster" : @1,
                              @"haveAction": @0
                              },
                          @{
                              @"name" : @"Weights (LowerBody)",
                              @"sessionTypeId" :   @1,
                              @"bodyTypeId" :   @2
                              },
                          @{
                              @"name" : @"Weights (UpperBody)",
                              @"sessionTypeId" :   @1,
                              @"bodyTypeId" :   @3
                              },
                          @{
                              @"name" : @"Weights (FullBody)",
                              @"sessionTypeId" :   @1,
                              @"bodyTypeId" :   @1
                              },
                          @{
                              @"name" : @"HIIT",
                              @"sessionTypeId" :   @2,
                              @"bodyTypeId" : @0
                              },
                          @{
                              @"name" : @"Pilates",
                              @"sessionTypeId" :   @3,
                              @"bodyTypeId" : @0
                              },
                          @{
                              @"name" : @"Yoga",
                              @"sessionTypeId" :   @4,
                              @"bodyTypeId" : @0
                              }
                          
                          //                          @{
                          //                              @"name" : @"Cardio",
                          //                              @"id" : @5
                          //                              }
                          ] mutableCopy];
    bwDict = [@{      @"2" : @"BW",
                      @"3" : @"SS",
                      @"1" : @"EQ"} mutableCopy];
    [submitDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
    [submitDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
    [submitDict setObject:AccessKey_ABBBC forKey:@"Key"];
    [submitDict setObject:[NSNumber numberWithInt:7] forKey:@"UserStep"];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self getData];
        [self checkStepNumberForSetupWithAPI:@"CheckStepNumberForSetup"];
    });
}
-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    moveColViewHeightConstraint.constant = moveCollectionView.contentSize.height;
    [self.view setNeedsUpdateConstraints];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - API Calls
-(void) getData {
    if (Utility.reachable) {
        apiCount++;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
            self->contentView = [Utility activityIndicatorView:self];
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
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"SetUpSquadUserSession" append:@""forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[customSession dataTaskWithRequest:request
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
                                                                          [self->responseObjArray removeAllObjects];
                                                                          [self->responseObjArray addObjectsFromArray:[responseDict objectForKey:@"SquadUserExerciseDays"]];
                                                                          [self->secondTableView reloadData];
                                                                          [self->thirdTableView reloadData];
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

-(void) swapApiCall {
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
        
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        [mainDict addEntriesFromDictionary:swapDict];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"SquadSwapExerciseSession" append:@""forAction:@"POST"];
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
                                                                      if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"]boolValue]) {
                                                                          self->selectedIndex = -1;
                                                                          self->selectedTable = -1;
                                                                          self->cancelMoveButton.hidden = true;
                                                                          [self getData];
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
-(void) updatedUserProgramSetupStepNo:(int) stepNumber{
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
        [mainDict setObject:[NSNumber numberWithInteger:stepNumber] forKey:@"StepNumber"];
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
                                                                  if (self->contentView) {
                                                                      [self->contentView removeFromSuperview];
                                                                  }
                                                                  if(error == nil)
                                                                  {
                                                                      NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                      NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                      if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"]boolValue]) {
                                                                          //current week
                                                                          //if([[self.navigationController.viewControllers firstObject] isKindOfClass:[TrailHomeViewController class]]){
                                                                          
                                                                          //Change_26032018
                                                                          //                                                                          if(![Utility isEmptyCheck:[defaults objectForKey:@"SendToCustomPlan"]]){
                                                                          //                                                                              [self webSerViceCall_SquadNutritionSettingStep];
                                                                          //                                                                          }else{
                                                                          //FIREBASELOG
                                                                          [FIRAnalytics logEventWithName:@"unlock_achievement" parameters:@{@"workout_plan":@"completed"}];
                                                                        
                                                                          
                                                                          [self webSerViceCall_GetSquadCurrentProgram];
                                                                          // }
                                                                          
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

-(void) checkStepNumberForSetupWithAPI:(NSString *)apiName {
    if (Utility.reachable) {
        apiCount++;
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
                                                                  self->apiCount--;
                                                                  if (self->contentView && self->apiCount == 0) {
                                                                      [self->contentView removeFromSuperview];
                                                                  }
                                                                  if(error == nil)
                                                                  {
                                                                      NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                      NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                      if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"SuccessFlag"]boolValue]) {
                                                                          
                                                                          [defaults setInteger:[[responseDict objectForKey:@"StepNumber"] intValue] forKey:@"CustomExerciseStepNumber"];
                                                                          
                                                                          //                                                                          if ([defaults integerForKey:@"CustomExerciseStepNumber"] == 0) {
                                                                          //                                                                              backToExSettingsButton.hidden=false;
                                                                          //                                                                          } else {
                                                                          //                                                                              backToExSettingsButton.hidden = true;
                                                                          //                                                                              backExButtonHeightConstraint.constant = 0;
                                                                          //                                                                          }
                                                                          
                                                                          switch ([[responseDict objectForKey:@"StepNumber"] intValue]) {
                                                                                  
                                                                              case -1:
                                                                                  //api call
                                                                                  [self checkStepNumberForSetupWithAPI:@"CheckUserProgramStep"];
                                                                                  break;
                                                                                  
                                                                              default:
                                                                                  self->customProgramStep = [[responseDict objectForKey:@"StepNumber"] intValue];
                                                                                  //if([[self.navigationController.viewControllers firstObject] isKindOfClass:[TrailHomeViewController class]] || [defaults boolForKey:@"IsNonSubscribedUser"]){
                                                                                  if(![Utility isSubscribedUser]){
                                                                                      self->nextForNonSubscribedUser.hidden = false;
                                                                                  }else{
                                                                                      self->nextForNonSubscribedUser.hidden = true;
                                                                                  }
                                                                                  //SbChange
                                                                                  if(self->customProgramStep == 0){
                                                                                      [self->exercisePlanButton setBackgroundColor:[Utility colorWithHexString:@"E425A0"]];
                                                                                         [self->exercisePlanButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                                                                                      [self->exercisePlanButton setTitle:@"BACK TO EXERCISE SETTINGS" forState:UIControlStateNormal];
                                                                                  }else{
                                                                                      [self->exercisePlanButton setBackgroundColor:[Utility colorWithHexString:@"93E2DD"]];
                                                                                      [self->exercisePlanButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                                                                                      [self->exercisePlanButton setTitle:@"COMPLETE SETTINGS" forState:UIControlStateNormal];
                                                                                  }
                                                                                  //SbChange
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
}

-(void) quickSwapApiCall {
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
            self->contentView = [Utility activityIndicatorView:self];
        });
        
        NSURLSession *customSession = [NSURLSession sharedSession];
        
        NSError *error;
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:submitDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"QuickSwapExerciseSession" append:@""forAction:@"POST"];
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
                                                                      if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"]boolValue]) {
                                                                          self->selectedIndex = -1;
                                                                          self->selectedTable = -1;
                                                                          self->cancelMoveButton.hidden = true;
                                                                          [self getData];
                                                                          [self sessionBack:nil];
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

-(void)webSerViceCall_GetSquadCurrentProgram{
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
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetSquadCurrentProgram" append:@""forAction:@"POST"];
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
                                                                         currprogram = [responseDict objectForKey:@"SquadProgram"];
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
                                                                         if (stepnumber == 0) {
                                                                             ViewPersonalSessionViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ViewPersonalSession"];
                                                                             [self.navigationController pushViewController:controller animated:YES];
                                                                         }else{
                                                                             [self checkNutritionStep:stepnumber];
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
-(void)checkNutritionStep:(int)tag{
    
    UIViewController *myController;
    if ((stepnumber == -1 || stepnumber == 1) && [Utility isEmptyCheck:currprogram] )   {//add1
        ChooseGoalViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ChooseGoal"];
        controller.isNutritionSettings=true;
        myController = controller;
    }else if((stepnumber == -1 && ![Utility isEmptyCheck:currprogram])){//add1
        DietaryPreferenceViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DietaryPreferenceView"];
        myController = controller;
    }
    else if (stepnumber == 1 || stepnumber == 2) {
        DietaryPreferenceViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DietaryPreferenceView"];
        myController = controller;
    }
    else if (stepnumber == 3) {
        MealFrequencyViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MealFrequencyView"];
        myController = controller;
    }else if (stepnumber == 4){
        MealVarietyViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MealVarietyView"];
        myController = controller;
    }else if (stepnumber == 5){
        MealPlanViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MealPlanView"];
        myController = controller;
    }
    [self.navigationController pushViewController:myController animated:YES];
  
}

#pragma -mark - IBAction
-(IBAction)homeButtonPressed:(UIButton*)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)menuButtonPressed:(id)sender {
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
    [self.slidingViewController resetTopViewAnimated:YES];
}

-(IBAction)backButtonPressed:(id)sender{
    //    [self.navigationController popViewControllerAnimated:YES];
    PersonalSessionsViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PersonalSessions"];
    [self.navigationController pushViewController:controller animated:NO];
}
-(IBAction)nextButtonPressed:(id)sender{
    //    NSLog(@"coa %@",customResponseObjArray);
    //current week
    //if([[self.navigationController.viewControllers firstObject] isKindOfClass:[TrailHomeViewController class]]){
    if(![Utility isEmptyCheck:[defaults objectForKey:@"SendToCustomPlan"]]){
        
    }else{
        //FIREBASELOG
        [FIRAnalytics logEventWithName:@"unlock_achievement" parameters:@{@"workout_plan":@"completed"
                                                                          }];
        ViewPersonalSessionViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ViewPersonalSession"];
        [self.navigationController pushViewController:controller animated:YES];
    }
}
- (IBAction)nextForNonSubscribedUserPressed:(UIButton *)sender {
    //    NSLog(@"%@",self.navigationController.viewControllers);
    //    //if([[self.navigationController.viewControllers firstObject] isKindOfClass:[TrailHomeViewController class]]){
    //    if((![Utility isEmptyCheck:[defaults objectForKey:@"SendToCustomPlan"]])){
    if (customProgramStep == 0) {
        // [self webSerViceCall_SquadNutritionSettingStep];  //Change_26032018
        [FIRAnalytics logEventWithName:@"unlock_achievement" parameters:@{@"workout_plan":@"completed"
                                                                          }];
        ViewPersonalSessionViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ViewPersonalSession"];
        [self.navigationController pushViewController:controller animated:YES];
    }else{
        //complete
        [self updatedUserProgramSetupStepNo:0];
        //redirect to current week
        
        //FIREBASELOG
        [FIRAnalytics logEventWithName:@"unlock_achievement" parameters:@{@"workout_plan":@"completed"
                                                                          }];
    }
    
    /*}else{
     //FIREBASELOG
     [FIRAnalytics logEventWithName:@"unlock_achievement" parameters:@{@"workout_plan":@"completed"
     }];
     ViewPersonalSessionViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ViewPersonalSession"];
     [self.navigationController pushViewController:controller animated:YES];
     }*/
    
}


-(IBAction)cancelMoveButtonTapped:(id)sender {
    selectedIndex = -1;
    selectedTable = -1;
    [secondTableView reloadData];
    [thirdTableView reloadData];
    cancelMoveButton.hidden = YES;
}

-(IBAction)exercisePlanTapped:(id)sender {
    if (customProgramStep == 0) {
        //        //if([[self.navigationController.viewControllers firstObject] isKindOfClass:[TrailHomeViewController class]]){
        if(![Utility isEmptyCheck:[defaults objectForKey:@"SendToCustomPlan"]]){
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else{
            //settings
            CustomExerciseSettingsViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CustomExerciseSettings"];
            [self.navigationController pushViewController:controller animated:YES];
        }
    }else{
        //complete
        [self updatedUserProgramSetupStepNo:0];
        //redirect to current week
        
    }
    //    ViewPersonalSessionViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ViewPersonalSession"];
    //    [self.navigationController pushViewController:controller animated:YES];
}
-(IBAction)addButtonTapped:(id)sender {
    ViewPersonalSessionViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ViewPersonalSession"];
    [self.navigationController pushViewController:controller animated:YES];
}
-(IBAction)secondSelectButtonTapped:(UIButton *)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"tag %ld",(long)[sender tag]);
        self->selectedIndex = (int)[sender tag]-1001;
        self->selectedTable = 2;
        /*[secondTableView reloadData];
         [thirdTableView reloadData];
         cancelMoveButton.hidden = false;*/
        
        int dropDownSelectedIndex = -1;
        NSMutableArray *dropDownArray = [[NSMutableArray alloc] init];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self->selectedIndex inSection:0];
        MoveTableViewCell *cell = (MoveTableViewCell *) [self->secondTableView cellForRowAtIndexPath:indexPath];
        
        NSArray *sessionTypeArr = [self->sessionTypeDict allKeysForObject:cell.secondTitleLabel.text];
        if (![Utility isEmptyCheck:sessionTypeArr]) {
            [self->submitDict setObject:[sessionTypeArr objectAtIndex:0] forKey:@"OriginSessionType"];
        }
        [self->submitDict setObject:[NSNumber numberWithInt:0] forKey:@"OriginBodyType"];
        if (![Utility isEmptyCheck:cell.secondSubTitleLabel.text] && !cell.secondSubTitleLabel.isHidden) {
            NSArray *bodyTypeArr = [self->bodyTypeDict allKeysForObject:[cell.secondSubTitleLabel.text stringByReplacingOccurrencesOfString:@"- " withString:@""]];
            if (![Utility isEmptyCheck:bodyTypeArr]) {
                [self->submitDict setObject:[bodyTypeArr objectAtIndex:0] forKey:@"OriginBodyType"];
            }
        }
        [self->submitDict setObject:[NSNumber numberWithInt:self->selectedIndex] forKey:@"DayNumber"];
        
        
        if (cell.secondTitleLabel.alpha < 1) {
            [dropDownArray addObject:[self->sessionTypeArray objectAtIndex:0]];//self->sessionTypeArray.count-1]];
        } else {
            dropDownArray = self->sessionTypeArray;
            NSString *subText = ![Utility isEmptyCheck:cell.secondSubTitleLabel.text] && !cell.secondSubTitleLabel.isHidden ? [NSString stringWithFormat:@" (%@)",[[cell.secondSubTitleLabel.text mutableCopy] stringByReplacingOccurrencesOfString:@"- " withString:@""]] : @"";
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(name == %@)",[NSString stringWithFormat:@"%@%@",cell.secondTitleLabel.text,subText]];
            NSArray *filteredSessionCategoryArray = [self->sessionTypeArray filteredArrayUsingPredicate:predicate];
            if (filteredSessionCategoryArray.count > 0) {
                dropDownSelectedIndex = (int)[self->sessionTypeArray indexOfObject:[filteredSessionCategoryArray objectAtIndex:0]];
            }
        }
        //        if (selectedIndex > 0 && dropDownArray.count > 0) {
        //            NSDictionary *dict =dropDownArray[dropDownSelectedIndex];
        //            [dropDownArray removeObjectAtIndex:dropDownSelectedIndex];
        //            [dropDownArray insertObject:dict atIndex:1];
        //            dropDownSelectedIndex = 1;
        //        }
        
        DropdownViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Dropdown"];
        controller.modalPresentationStyle = UIModalPresentationCustom;
        controller.dropdownDataArray = dropDownArray;
        controller.mainKey = @"name";
        controller.apiType = @"SessionType";
        controller.haveMaster = YES;
        controller.selectedIndex = dropDownSelectedIndex;
        controller.shouldScrollToIndexpath = NO;
        controller.delegate = self;
        [self presentViewController:controller animated:YES completion:nil];
    });
}
-(IBAction)thirdSelectButtonTapped:(UIButton*)sender {
    NSLog(@"tag %ld",(long)[sender tag]);
    selectedIndex = (int)[sender tag]-2001;
    selectedTable = 3;
    [secondTableView reloadData];
    [thirdTableView reloadData];
    cancelMoveButton.hidden = false;
}
-(IBAction)secondMoveHereButtonTapped:(UIButton*)sender {
    NSLog(@"tag %ld",(long)[sender tag]);
    
    [swapDict setObject:[NSNumber numberWithInt:selectedIndex] forKey:@"DayFrom"];
    [swapDict setObject:[NSNumber numberWithInteger:[sender tag]-1] forKey:@"DayTo"];
    [swapDict setObject:[NSNumber numberWithBool:NO] forKey:@"IsFbw"];
    [self swapApiCall];
}
-(IBAction)thirdMoveHereButtonTapped:(UIButton*)sender {
    NSLog(@"tag %ld",(long)[sender tag]);
    
    [swapDict setObject:[NSNumber numberWithInt:selectedIndex] forKey:@"DayFrom"];
    [swapDict setObject:[NSNumber numberWithInteger:[sender tag]-101] forKey:@"DayTo"];
    [swapDict setObject:[NSNumber numberWithBool:YES] forKey:@"IsFbw"];
    [self swapApiCall];
}
-(IBAction)backToExerciseSettings:(id)sender {
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
- (IBAction)editButtonPressed:(UIButton *)sender {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    MoveTableViewCell *cell = (MoveTableViewCell *)[secondTableView cellForRowAtIndexPath:indexPath];
    CGSize hh = cell.frame.size;
    int h1 = hh.height;
    int y1 = cell.frame.origin.y;
    
    cX = mainScroll.contentOffset.x;
    cY = mainScroll.contentOffset.y;
    
    [mainScroll setContentOffset:CGPointMake(mainScroll.contentOffset.x, cY+60) animated:YES];
    editViewTopConstraint.constant = 368-cY+y1+(2*h1)-40-60;
    
    float triangleOrigin = 0.0;
    NSLog(@"Top:--%f",editViewTopConstraint.constant);
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        if (screenSize.height == 812){
            triangleOrigin = (editViewTopConstraint.constant+40)-5; //20 added for safe area iphoneX
        }else{
            triangleOrigin = editViewTopConstraint.constant-10;
        }
        
    }
    
    triangleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pink_triangle_inv.png"]];
    if ([sender.accessibilityHint caseInsensitiveCompare:@"2"] == NSOrderedSame) {
        
        triangleImageView.frame = CGRectMake(15+(1.5*cell.frame.size.width)-8, triangleOrigin, 16, 10);
        if (cell.secondTitleLabel.alpha >= 1) {
            editSessionButton.hidden = false;
        } else {
            editSessionButton.hidden = true;
        }
        
    } else {
        triangleImageView.frame = CGRectMake(15+(2.5*cell.frame.size.width)-8,triangleOrigin, 16, 10);
        editSessionButton.hidden = true;
    }
    
    [editView addSubview:triangleImageView];
    editView.hidden = false;
    moveSwapButton.tag = sender.tag;
    moveSwapButton.accessibilityHint = sender.accessibilityHint;
    editSessionButton.tag = sender.tag;
    editSessionButton.accessibilityHint = sender.accessibilityHint;
}
- (IBAction)crossButtonPressed:(UIButton *)sender {
    [triangleImageView removeFromSuperview];
    editView.hidden = true;
    [mainScroll setContentOffset:CGPointMake(cX, cY) animated:YES];
    
}
- (IBAction)sessionBack:(UIButton *)sender {
    sessionView.hidden = true;
}

- (IBAction)moveSwapEditSessionPressed:(UIButton *)sender {
    [self crossButtonPressed:nil];
    if ([sender.accessibilityHint caseInsensitiveCompare:@"2"] == NSOrderedSame) {
        if (sender == moveSwapButton) {
            selectedIndex = (int)[sender tag];
            selectedTable = 2;
            [secondTableView reloadData];
            [thirdTableView reloadData];
            cancelMoveButton.hidden = false;
        } else if (sender == editSessionButton) {
            self->selectedIndex = (int)[sender tag];
            self->selectedTable = 2;
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self->selectedIndex inSection:0];
            MoveTableViewCell *cell = (MoveTableViewCell *) [self->secondTableView cellForRowAtIndexPath:indexPath];
            
            NSArray *sessionTypeArr = [self->sessionTypeDict allKeysForObject:cell.secondTitleLabel.text];
            if (![Utility isEmptyCheck:sessionTypeArr]) {
                [self->submitDict setObject:[sessionTypeArr objectAtIndex:0] forKey:@"OriginSessionType"];
            }
            [self->submitDict setObject:[NSNumber numberWithInt:0] forKey:@"OriginBodyType"];
            if (![Utility isEmptyCheck:cell.secondSubTitleLabel.text] && !cell.secondSubTitleLabel.isHidden) {
                NSArray *bodyTypeArr = [self->bodyTypeDict allKeysForObject:[cell.secondSubTitleLabel.text stringByReplacingOccurrencesOfString:@"- " withString:@""]];
                if (![Utility isEmptyCheck:bodyTypeArr]) {
                    [self->submitDict setObject:[bodyTypeArr objectAtIndex:0] forKey:@"OriginBodyType"];
                }
            }
            [self->submitDict setObject:[NSNumber numberWithInt:self->selectedIndex] forKey:@"DayNumber"];
            
            NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"Day == %d", (int)sender.tag];
            NSArray *filterArray = [responseObjArray filteredArrayUsingPredicate:predicate1];
            if (filterArray.count>0) {
                NSDictionary *temp = [filterArray objectAtIndex:0];
                sessionView.hidden = false;
                sessionStackView.hidden = true;
                newSessionTypeLabel.text = [NSString stringWithFormat:@"Edit %@ - %@",[sessionTypeDict objectForKey:[[temp objectForKey:@"Session1Type"] stringValue]],![Utility isEmptyCheck:temp[@"NewSessionType"]]?temp[@"NewSessionType"]:[bodyTypeDict objectForKey:[[temp objectForKey:@"BodyType"] stringValue]]];//temp[@"NewSessionType"]];
                for (UIButton *btn in weightGymButtonCollection) {
                    btn.layer.borderWidth = 1;
                    btn.layer.borderColor = [UIColor colorWithRed:228/255.0f green:39/255.0f blue:160/255.0f alpha:1.0].CGColor;
                    btn.selected = false;
                    [btn setBackgroundColor:[UIColor whiteColor]];
                }
                for (UIButton *btn in weightGymOptionButtonCollection) {
                    btn.layer.borderWidth = 1;
                    btn.layer.borderColor = [UIColor colorWithRed:228/255.0f green:39/255.0f blue:160/255.0f alpha:1.0].CGColor;
                    btn.selected = false;
                    if (btn.tag > 4) {
                        [btn setBackgroundColor:[UIColor whiteColor]];
                    }
                }
                for (UIView *myView in weightViewCollection) {
                    [myView setBackgroundColor:[UIColor whiteColor]];
                }
                for (UILabel *myLabel in weightLabelCollection) {
                    [myLabel setTextColor:[UIColor colorWithRed:228/255.0f green:39/255.0f blue:160/255.0f alpha:1.0]];
                }
            }
        }
    } else {
        if (sender == moveSwapButton) {
            selectedIndex = (int)[sender tag];
            selectedTable = 3;
            [secondTableView reloadData];
            [thirdTableView reloadData];
            cancelMoveButton.hidden = false;
        } else if (sender == editSessionButton) {
            //
        }
    }
    
}
- (IBAction)weightGymButtonPressed:(UIButton *)sender {
    sessionStackView.hidden = false;
    for (UIView *myView in weightViewCollection) {
        [myView setBackgroundColor:[UIColor whiteColor]];
    }
    for (UILabel *myLabel in weightLabelCollection) {
        [myLabel setTextColor:[UIColor colorWithRed:228/255.0f green:39/255.0f blue:160/255.0f alpha:1.0]];
    }
    for (UIButton *btn in weightGymOptionButtonCollection) {
        if (btn.tag > 4) {
            btn.selected = false;
            [btn setBackgroundColor:[UIColor whiteColor]];
        }
    }
    for (UIButton *btn in weightGymButtonCollection) {
        if(btn == sender){
            btn.selected = true;
            [btn setBackgroundColor:[UIColor colorWithRed:228/255.0f green:39/255.0f blue:160/255.0f alpha:1.0]];
        }else{
            btn.selected = false;
            [btn setBackgroundColor:[UIColor whiteColor]];
        }
    }
    if (sender.tag == 0) {
        [self->submitDict setObject:[NSNumber numberWithInt:2] forKey:@"EquipmentType"];
    } else if (sender.tag == 1) {
        [self->submitDict setObject:[NSNumber numberWithInt:3] forKey:@"EquipmentType"];
    } else if (sender.tag == 2) {
        [self->submitDict setObject:[NSNumber numberWithInt:1] forKey:@"EquipmentType"];
    }
}
- (IBAction)weightGymOptionPressed:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    for (UIButton *btn in weightGymOptionButtonCollection) {
        if (sender.tag > 4) {
            if(btn == sender){
                btn.selected = true;
                [btn setBackgroundColor:[UIColor colorWithRed:228/255.0f green:39/255.0f blue:160/255.0f alpha:1.0]];
                break;
            }
        }else{
            UIView *temp = weightViewCollection[sender.tag - 2];
            [temp setBackgroundColor:[UIColor colorWithRed:228/255.0f green:39/255.0f blue:160/255.0f alpha:1.0]];
            UILabel *myLabel;
            if (sender.tag == 2) {
                myLabel = weightLabelCollection[0];
                [myLabel setTextColor:[UIColor whiteColor]];
                myLabel = weightLabelCollection[1];
                [myLabel setTextColor:[UIColor whiteColor]];
            } else if (sender.tag == 3) {
                myLabel = weightLabelCollection[2];
                [myLabel setTextColor:[UIColor whiteColor]];
                myLabel = weightLabelCollection[3];
                [myLabel setTextColor:[UIColor whiteColor]];
            } else if (sender.tag == 4) {
                myLabel = weightLabelCollection[4];
                [myLabel setTextColor:[UIColor whiteColor]];
                myLabel = weightLabelCollection[5];
                [myLabel setTextColor:[UIColor whiteColor]];
            }
            break;
        }
    }
    if (sender.isSelected) {
        NSDictionary *selectedData = [[NSDictionary alloc]initWithDictionary:[sessionTypeArray objectAtIndex:sender.tag]];
        [submitDict setObject:[selectedData objectForKey:@"sessionTypeId"] forKey:@"SessionType"];
        [submitDict setObject:[selectedData objectForKey:@"bodyTypeId"] forKey:@"BodyType"];
        
        [self quickSwapApiCall];
    }
    
}

#pragma mark - DropDownViewDelegate
- (void) didSelectAnyDropdownOption:(NSString *)type data:(NSDictionary *)selectedData{
    NSLog(@"ty %@ \ndata %@",type,selectedData);
    
    if ([type caseInsensitiveCompare:@"SessionType"] == NSOrderedSame) {
        if ([[selectedData objectForKey:@"name"] caseInsensitiveCompare:@"Move/Swap"] == NSOrderedSame) {
            [secondTableView reloadData];
            [thirdTableView reloadData];
            cancelMoveButton.hidden = false;
        } else {
            [submitDict setObject:[selectedData objectForKey:@"sessionTypeId"] forKey:@"SessionType"];
            [submitDict setObject:[selectedData objectForKey:@"bodyTypeId"] forKey:@"BodyType"];
            [self quickSwapApiCall];
        }
    }
}
#pragma mark - CollectionView DataSource/Delegate
/*- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
 
 return 21;
 }
 
 - (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
 static NSString *identifier = @"MoveCollectionViewCell";
 
 MoveCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
 
 if ([[customResponseObjArray objectAtIndex:indexPath.row] isKindOfClass:[NSDictionary class]]) {
 cell.moveColViewLabel.text = [[customResponseObjArray objectAtIndex:indexPath.row] objectForKey:@"SessionTitle"];
 cell.moveColViewEqualImageView.hidden = false;
 } else if ([[customResponseObjArray objectAtIndex:indexPath.row] isKindOfClass:[NSString class]]) {
 if ([[customResponseObjArray objectAtIndex:indexPath.row] caseInsensitiveCompare:@"noData"] == NSOrderedSame) {
 cell.moveColViewLabel.text = @"";
 } else {
 cell.moveColViewLabel.text = [customResponseObjArray objectAtIndex:indexPath.row];
 }
 cell.moveColViewEqualImageView.hidden = true;
 }
 
 return cell;
 }
 
 - (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
 //    NSLog(@"ip %ld",(long)indexPath.row);
 
 
 }
 - (CGSize)collectionView:(UICollectionView *)collectionView
 layout:(UICollectionViewLayout *)collectionViewLayout
 sizeForItemAtIndexPath:(NSIndexPath *)indexPath
 {
 CGRect screenRect = [[UIScreen mainScreen] bounds];
 CGFloat screenWidth = screenRect.size.width;
 float cellWidth = screenWidth / 3.0; //Replace the divisor with the column count requirement. Make sure to have it in float.
 CGSize size = CGSizeMake(cellWidth, 50);
 
 return size;
 }*/

#pragma mark - TableView Datasource & Delegate


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == firstTableView && weekdays.count > 0) {
        return 7;
    } else {
        if (responseObjArray.count > 0) {
            return 7;
        }
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *CellIdentifier = @"MoveTableViewCell";
    MoveTableViewCell *cell = (MoveTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // Configure the cell...
    if (cell == nil) {
        cell = [[MoveTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"Day == %d", indexPath.row];
    NSArray *filterArray = [responseObjArray filteredArrayUsingPredicate:predicate1];
    if (tableView == secondTableView) {
        if (filterArray.count > 0) {
            if (![Utility isEmptyCheck:[[filterArray objectAtIndex:0] objectForKey:@"Session1Type"]]) {
                
                cell.secondTitleLabel.text = [sessionTypeDict objectForKey:[[[filterArray objectAtIndex:0] objectForKey:@"Session1Type"] stringValue]];
                int sNo = [[[filterArray objectAtIndex:0] objectForKey:@"Session1Type"] intValue];
                if (sNo > 1 && sNo < 5) {
                    NSString *txt = [NSString stringWithFormat:@"%@",![Utility isEmptyCheck:[[filterArray objectAtIndex:0] objectForKey:@"EquipmentTypeId"]]?[NSString stringWithFormat:@"(%@)",[bwDict objectForKey:[[[filterArray objectAtIndex:0] objectForKey:@"EquipmentTypeId"] stringValue]]]:@""];
                    cell.secondTitleLabel.text = [NSString stringWithFormat:@"%@ %@",[sessionTypeDict objectForKey:[[[filterArray objectAtIndex:0] objectForKey:@"Session1Type"] stringValue]],txt];
                }
                if ([[[filterArray objectAtIndex:0] objectForKey:@"Session1Type"] intValue] == 1) {
                    
                    if (![Utility isEmptyCheck:[[filterArray objectAtIndex:0] objectForKey:@"NewSessionType"]])
                        cell.secondSubTitleLabel.text = [NSString stringWithFormat:@"- %@",[[filterArray objectAtIndex:0] objectForKey:@"NewSessionType"]];
                    else if (![Utility isEmptyCheck:[[filterArray objectAtIndex:0] objectForKey:@"BodyType"]]){
                        NSString *txt = [NSString stringWithFormat:@"%@",![Utility isEmptyCheck:[[filterArray objectAtIndex:0] objectForKey:@"EquipmentTypeId"]]?[NSString stringWithFormat:@"(%@)",[bwDict objectForKey:[[[filterArray objectAtIndex:0] objectForKey:@"EquipmentTypeId"] stringValue]]]:@""];
                        cell.secondSubTitleLabel.text = [NSString stringWithFormat:@"- %@ %@",[bodyTypeDict objectForKey:[[[filterArray objectAtIndex:0] objectForKey:@"BodyType"] stringValue]],txt];
                        
                    }
                    
                    
                    cell.secondTitleLabel.alpha = 1.0;
                } else {
                    if (![Utility isEmptyCheck:[[filterArray objectAtIndex:0] objectForKey:@"NewSessionType"]])
                        cell.secondSubTitleLabel.text = [NSString stringWithFormat:@"- %@",[[filterArray objectAtIndex:0] objectForKey:@"NewSessionType"]];
                    cell.secondTitleLabel.alpha = 0.4;
                }
                
                //                if ([[[filterArray objectAtIndex:0] objectForKey:@"IsPersonalised"] boolValue])
                //                    [cell.secondSelectButton addTarget:self action:@selector(secondSelectButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
                cell.secondSelectButton.tag = indexPath.row+1001;
                
                [cell.secondMoveHereButton setTitle:@"Swap Here" forState:UIControlStateNormal];
                
                cell.secondEqualImageView.hidden = false;
                
                if (![[[filterArray objectAtIndex:0] objectForKey:@"IsPersonalised"] boolValue] && [[[filterArray objectAtIndex:0] objectForKey:@"Session1Type"] intValue] != 1) {
                    cell.secondSubTitleLabel.hidden = true;
                    cell.secondTitleLabel.alpha = 1.0;
                } else {
                    cell.secondSubTitleLabel.hidden = false;
                    
                }
                cell.editButton.hidden = false;
                cell.secondSelectButton.enabled = true;
            }
            else {
                cell.secondTitleLabel.text = @"" ;
                cell.secondSubTitleLabel.text = @"" ;
                
                [cell.secondMoveHereButton setTitle:@"Move Here" forState:UIControlStateNormal];
                
                cell.secondEqualImageView.hidden = true;
                cell.editButton.hidden = true;
                cell.secondSelectButton.enabled = false;
            }
            
        } else {
            cell.secondTitleLabel.text = @"" ;
            
            [cell.secondMoveHereButton setTitle:@"Move Here" forState:UIControlStateNormal];
            
            cell.secondEqualImageView.hidden = true;
            cell.editButton.hidden = true;
            cell.secondSelectButton.enabled = false;
        }
        
        [cell.secondMoveHereButton addTarget:self
                                      action:@selector(secondMoveHereButtonTapped:)
                            forControlEvents:UIControlEventTouchUpInside];
        cell.secondMoveHereButton.tag = indexPath.row+1;
        
        if (selectedTable == 2 && selectedIndex == (int)indexPath.row) {
            cell.secondMoveHereButton.hidden = YES;
        } else if (selectedTable == 2) {
            cell.secondMoveHereButton.hidden = NO;
        } else {
            cell.secondMoveHereButton.hidden = YES;
        }
        cell.editButton.tag = indexPath.row;
        cell.editButton.accessibilityHint = @"2";
    } else if (tableView == thirdTableView) {
        if (filterArray.count > 0) {
            if (![Utility isEmptyCheck:[[filterArray objectAtIndex:0] objectForKey:@"Session2Type"]]){
                
                cell.thirdTitleLabel.text = [sessionTypeDict objectForKey:[[[filterArray objectAtIndex:0] objectForKey:@"Session2Type"] stringValue]] ;
                
                //                if ([[[filterArray objectAtIndex:0] objectForKey:@"IsPersonalised"] boolValue])
                //                    [cell.thirdSelectButton addTarget:self action:@selector(thirdSelectButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
                cell.thirdSelectButton.tag = indexPath.row+2001;
                
                [cell.thirdMoveHereButton setTitle:@"Swap Here" forState:UIControlStateNormal];
                
                cell.thirdEqualImageView.hidden = false;
                cell.editButton.hidden = false;
            }
            else {
                cell.thirdTitleLabel.text = @"";
                [cell.thirdMoveHereButton setTitle:@"Move Here" forState:UIControlStateNormal];
                cell.thirdEqualImageView.hidden = true;
                cell.editButton.hidden = true;
            }
        } else {
            cell.thirdTitleLabel.text = @"" ;
            [cell.thirdMoveHereButton setTitle:@"Move Here" forState:UIControlStateNormal];
            cell.thirdEqualImageView.hidden = true;
            cell.editButton.hidden = true;
        }
        
        [cell.thirdMoveHereButton addTarget:self
                                     action:@selector(thirdMoveHereButtonTapped:)
                           forControlEvents:UIControlEventTouchUpInside];
        cell.thirdMoveHereButton.tag = indexPath.row+101;
        
        if (selectedTable == 3 && selectedIndex == (int)indexPath.row) {
            cell.thirdMoveHereButton.hidden = YES;
        } else if (selectedTable == 3) {
            cell.thirdMoveHereButton.hidden = NO;
        } else {
            cell.thirdMoveHereButton.hidden = YES;
        }
        cell.editButton.tag = indexPath.row;
        cell.editButton.accessibilityHint = @"3";
    } else if (tableView == firstTableView) {
        cell.dayNameLabel.text = [weekdays objectAtIndex:indexPath.row];
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //    selectedIndex = (int)indexPath.row;
    //    if (tableView == secondTableView) {
    //        selectedTable = 2;
    //    } else if (tableView == thirdTableView) {
    //        selectedTable = 3;
    //    }
    //    [tableView reloadData];
}

@end
