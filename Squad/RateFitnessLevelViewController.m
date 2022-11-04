//
//  RateFitnessLevelViewController.m
//  Squad
//
//  Created by AQB Mac 4 on 17/01/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import "RateFitnessLevelViewController.h"
#import "MasterMenuViewController.h"
#import "ChooseGoalTableViewCell.h"
#import "RateFitnessLevelHeaderView.h"
#import "PersonalSessionsViewController.h"
#import "ChooseGoalViewController.h"
#import "ViewPersonalSessionViewController.h"
#import "CustomExerciseSettingsViewController.h"

static NSString *RateFitnessLevelHeaderViewIdentifier = @"RateFitnessLevelHeaderView";

@interface RateFitnessLevelViewController (){
    IBOutlet NSLayoutConstraint *footerConstant;
    IBOutlet UIButton *menuButton;
    IBOutlet UITableView *table;
    IBOutlet UILabel *header;
    IBOutlet UILabel *pageNumber;

    IBOutlet UIButton *nextButton;
    
    IBOutlet UIButton *backToExSettingsButton;
    IBOutlet NSLayoutConstraint *backExButtonHeightConstraint;
    IBOutlet UIButton *applyButton;
    IBOutlet UILabel *applyTextLabel;
    IBOutlet UIView *applyLineView;
    IBOutlet UILabel *mainHeaderLabel;
    NSArray *fitnessLevelArray;
    NSMutableDictionary *selectedSectionDict;
    UIView *contentView;    //ah new
    
    NSMutableDictionary *responseObjDict;
    NSMutableArray *responseObjArr;
    BOOL isChanged;
    
    NSArray *filterArray;
    NSInteger selectedIndex;
    NSInteger selectIndexForWeeklySessionForSectonOne;
    NSInteger selectIndexForWeeklySessionForSectontwo;
}

@end

@implementation RateFitnessLevelViewController
@synthesize isRateFitness,isWeeklySession;
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self sizeHeaderToFit];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //if([[self.navigationController.viewControllers firstObject] isKindOfClass:[TrailHomeViewController class]]){
    selectedIndex = -1;
    
    if(![Utility isSubscribedUser]){
        menuButton.hidden = true;
        footerConstant.constant = 0;
    }else{
        menuButton.hidden = false;
        footerConstant.constant = 75;
    }
    
    selectedSectionDict = [[NSMutableDictionary alloc]init];
    responseObjDict = [[NSMutableDictionary alloc]init];
    responseObjArr = [[NSMutableArray alloc]init];
    filterArray = [[NSArray alloc] init];
    isChanged = NO;
    
    nextButton.hidden = true;

    table.estimatedRowHeight=40;
    table.sectionFooterHeight = CGFLOAT_MIN;
    table.rowHeight = UITableViewAutomaticDimension;
    table.sectionHeaderHeight = CGFLOAT_MIN;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    UINib *sectionHeaderNib = [UINib nibWithNibName:@"RateFitnessLevelHeaderView" bundle:nil];
    [table registerNib:sectionHeaderNib forHeaderFooterViewReuseIdentifier:RateFitnessLevelHeaderViewIdentifier];
    table.sectionHeaderHeight = UITableViewAutomaticDimension;
    table.estimatedSectionHeaderHeight = 40;
    if (isRateFitness) {
        mainHeaderLabel.text = @"Your Fitness Label";
        pageNumber.text = @"3 of 7";
        table.allowsMultipleSelection = NO;
        header.text = @"How do you rate your current fitness level?";
        fitnessLevelArray = @[
                              @{
                                  @"fitnessLevel" : @"I've never lifted weights, and rarely exercise/ its been 5 years since i exercised.",
                                  @"isdropdown" : @false,
                                  },@{
                                  @"fitnessLevel" : @"I exercise, but haven't done much weight training. My fitness could be better.",
                                  @"isdropdown" : @false,
                                  },@{
                                  @"fitnessLevel" : @"I have lifted weight before, and am fairly fit. I like to push myself.",
                                  @"isdropdown" : @false,
                                  },@{
                                  @"fitnessLevel" : @"I am advanced in strength and fitness.I love to push my limit.",
                                  @"isdropdown" : @false,
                                  }
                              ];
//        [self getRateFitness];
        [self getEquipmentData];
    }else if (isWeeklySession) {
        table.allowsMultipleSelection = YES;
        selectIndexForWeeklySessionForSectonOne = -1;
        selectIndexForWeeklySessionForSectontwo = -1;
        mainHeaderLabel.text= @"Weekly Session Commitment";
        pageNumber.text = @"5 of 7";
//        NSLog(@"%@",[UIFont fontNamesForFamilyName:@"Raleway"]);
//        header.font=[UIFont fontWithName:@"Raleway" size:13];
        header.text = @"\nPlease choose how many SESSIONS and FBW's you can commit to doing each week \n\n(you can update this at a later date in settings if you want to do more or less) \n";
        fitnessLevelArray = @[
                                @{
                                  @"recomendationName" : @"Weekly Session",
                                  @"recomendationDetails" :@[
                                          @{
                                              @"sessionName" : @"2 Session/Week",
                                              @"isdropdown" : @false
                                              },@{
                                              @"sessionName" : @"3 Session/Week",
                                              @"isdropdown" : @false
                                              },@{
                                              @"sessionName" : @"4 Session/Week",
                                              @"isdropdown" : @false
                                              },@{
                                              @"sessionName" : @"5 Session/Week",
                                              @"isdropdown" : @false
                                              },@{
                                              @"sessionName" : @"6 Session/Week",
                                              @"isdropdown" : @false
                                              }
                                          
                                          ]
                                  },@{
                                    @"recomendationName" : @"Fat Burning Walk",
                                    @"recomendationDetails" :@[
                                            @{
                                                @"sessionName" : @"1 FBW/Week",
                                                @"isdropdown" : @false
                                                },@{
                                                @"sessionName" : @"2 FBW/Week",
                                                @"isdropdown" : @false
                                                },@{
                                                @"sessionName" : @"3 FBW/Week",
                                                @"isdropdown" : @false
                                                },@{
                                                @"sessionName" : @"4 FBW/Week",
                                                @"isdropdown" : @false
                                                },@{
                                                @"sessionName" : @"5 FBW/Week",
                                                @"isdropdown" : @false
                                                },@{
                                                @"sessionName" : @"6 FBW/Week",
                                                @"isdropdown" : @false
                                                }
                                            
                                            ]
                                    }
                              ];
         [self getRateFitness];
    }else{
        table.allowsMultipleSelection = NO;
        mainHeaderLabel.text = @"Equipment";
        pageNumber.text = @"4 of 7";
        header.text = @"Equipment";
        fitnessLevelArray = @[
                              @{
                                  @"equipmentName" : @"Body Weight Only: \nI don't have any access to fitness equipment and normally workout at home.",
                                  @"isdropdown" : @false,
                                  },@{
                                  @"equipmentName" : @"Squad Straps: \nI have a set of Squad Straps or TRX.",
                                  @"isdropdown" : @false,
                                  },@{
                                  @"equipmentName" : @"I Have a Gym Membership: \nI have access to weights and a range of fitness equipment.",
                                  @"isdropdown" : @false,
                                  }
                              ];
        for (int i=0; i <fitnessLevelArray.count; i++) {
            [selectedSectionDict setObject:[NSNumber numberWithBool:NO] forKey:[NSNumber numberWithInteger:i]];
        }
        [self getEquipmentData];
    }
    
    //if([[self.navigationController.viewControllers firstObject] isKindOfClass:[TrailHomeViewController class]] || [defaults boolForKey:@"IsNonSubscribedUser"]){
    if(![Utility isSubscribedUser]){
        backToExSettingsButton.hidden = true;
        backExButtonHeightConstraint.constant = 0;
    }else{
        if ([defaults integerForKey:@"CustomExerciseStepNumber"] == 0) {
            backToExSettingsButton.hidden=false;
            backExButtonHeightConstraint.constant = 40;
        }else {
            backToExSettingsButton.hidden = true;
            backExButtonHeightConstraint.constant = 0;
        }
    }
   [self applyButtonFunction:NO];
}
#pragma mark -APICall
-(void)saveRateFitness {
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (contentView) {
                [contentView removeFromSuperview];
            }
            contentView = [Utility activityIndicatorView:self];
        });
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSError *error;
//        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        
////        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
//        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
////        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
//        [mainDict setObject:[NSNumber numberWithBool:YES] forKey:@"IsPersonalised"];
//        [mainDict setObject:[NSNumber numberWithBool:YES] forKey:@"NeedToUpdate"];
//        [mainDict setObject:[NSNumber numberWithInt:0] forKey:@"WeightLossRange"];
//        [mainDict setObject:[NSNumber numberWithBool:YES] forKey:@"DifficultyHoldingMuscle"];
        
        
        [responseObjDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        if ([Utility isEmptyCheck:[responseObjDict objectForKey:@"FitnessRatingId"]] || [[responseObjDict objectForKey:@"FitnessRatingId"] intValue] == 0) {     //ah 8.5
            if ([Utility isEmptyCheck:[defaults objectForKey:@"FitnessRatingId"]]) {
                //alert
                [self showAlert];
            } else {
                [responseObjDict setObject:[defaults objectForKey:@"FitnessRatingId"] forKey:@"FitnessRatingId"];
            }
        }
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:responseObjDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"CreateSquadExercisePlan" append:@""forAction:@"POST"];
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
                                                                        if (isRateFitness) {
                                                                            nextButton.hidden = false;
                                                                            [self updatedUserProgramSetupStepNo:4];
                                                                             RateFitnessLevelViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"RateFitnessLevel"];
                                                                             controller.isRateFitness= false;
                                                                             controller.isWeeklySession = false;
                                                                             [self.navigationController pushViewController:controller animated:YES];
                                                                         }else if (isWeeklySession) {
                                                                             nextButton.hidden = false;
                                                                             [self updatedUserProgramSetupStepNo:6];
                                                                             PersonalSessionsViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PersonalSessions"];
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
-(void)getRateFitness {
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (contentView) {
                [contentView removeFromSuperview];
            }
            contentView = [Utility activityIndicatorView:self];
        });
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSMutableURLRequest *request = [Utility getRequest:@"" api:@"GetSquadExercisePlan" append:[[defaults objectForKey:@"ABBBCOnlineUserId"] stringValue] forAction:@"GET"];
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
                                                                         if (isWeeklySession && ![Utility isEmptyCheck:[responseDict objectForKey:@"obj"]]) {
                                                                             [responseObjDict addEntriesFromDictionary:[responseDict objectForKey:@"obj"]];
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

-(void) getEquipmentData {
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (contentView) {
                [contentView removeFromSuperview];
            }
            contentView = [Utility activityIndicatorView:self];
        });
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSMutableURLRequest *request = [Utility getRequest:@"" api:@"GetUserFlags" append:[[defaults objectForKey:@"ABBBCOnlineUserId"] stringValue] forAction:@"GET"];
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
                                                                         NSString *attributeValue;
                                                                         
                                                                         if (isRateFitness) {
                                                                             [responseObjArr removeAllObjects];
                                                                             [responseObjArr addObjectsFromArray:[responseDict objectForKey:@"obj"]];
                                                                             attributeValue = @"Fitness_Rating";
                                                                         }else {
                                                                             [responseObjArr removeAllObjects];
                                                                             [responseObjArr addObjectsFromArray:[responseDict objectForKey:@"obj"]];
                                                                             attributeValue = @"Equipment";
                                                                         }
                                                                         
                                                                         NSString *attributeName  = @"FlagCategory";
                                                                         NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"(%K MATCHES %@)",attributeName,attributeValue];
                                                                         filterArray = [responseObjArr filteredArrayUsingPredicate:predicate1];
                                                                         
                                                                         [table reloadData];
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

-(void)saveEquipmentWithData:(NSMutableArray *)dataArr {
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
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:dataArr forKey:@"Values"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"AddUpateUserFlags" append:@"" forAction:@"POST"];
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
                                                                         [self updatedUserProgramSetupStepNo:5];
                                                                         RateFitnessLevelViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"RateFitnessLevel"];
                                                                         controller.isRateFitness = false;
                                                                         controller.isWeeklySession = true;
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
-(void) updatedUserProgramSetupStepNo:(int) stepNumber{
    if ([defaults integerForKey:@"CustomExerciseStepNumber"] > 0) { //< stepNumber) {
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
-(void)saveRateFitnessNewDict:(NSArray *)saveArr {
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
        
        [mainDict setObject:saveArr forKey:@"Values"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"AddUpdateUserFlags" append:@""forAction:@"POST"];
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
                                                                         [self updatedUserProgramSetupStepNo:4];
                                                                         RateFitnessLevelViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"RateFitnessLevel"];
                                                                         controller.isRateFitness= false;
                                                                         controller.isWeeklySession = false;
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
#pragma -mark IBAction
-(IBAction)homeButtonPressed:(UIButton*)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)menuButtonPressed:(id)sender {
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
    [self.slidingViewController resetTopViewAnimated:YES];
}

-(IBAction)backButtonPressed:(id)sender{
//    [self.navigationController popViewControllerAnimated:YES];
    if (isRateFitness) {
        ChooseGoalViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ChooseGoal"];
        [self.navigationController pushViewController:controller animated:NO];
    } else if (isWeeklySession) {
        RateFitnessLevelViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"RateFitnessLevel"];
        controller.isRateFitness = false;
        controller.isWeeklySession = false;
        [self.navigationController pushViewController:controller animated:NO];
    } else {
        RateFitnessLevelViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"RateFitnessLevel"];
        controller.isRateFitness = true;
        controller.isWeeklySession = false;
        [self.navigationController pushViewController:controller animated:NO];
    }
}
-(IBAction)nextButtonPressed:(id)sender{
    if (isWeeklySession){
        if (!isChanged) {
            [self updatedUserProgramSetupStepNo:6];
            PersonalSessionsViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PersonalSessions"];
            [self.navigationController pushViewController:controller animated:YES];
        }
    }else if (isRateFitness){
        [self updatedUserProgramSetupStepNo:4];
        RateFitnessLevelViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"RateFitnessLevel"];
        controller.isRateFitness = false;

        [self.navigationController pushViewController:controller animated:YES];
    }else{
        [self updatedUserProgramSetupStepNo:5];
        RateFitnessLevelViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"RateFitnessLevel"];
        controller.isRateFitness = false;
        controller.isWeeklySession = true;
        [self.navigationController pushViewController:controller animated:YES];
    }
}
- (IBAction)sectionExpandCollapse:(UIButton *)sender {
    if ([[selectedSectionDict objectForKey:[NSNumber numberWithInteger:sender.tag]]boolValue]) {
        [selectedSectionDict setObject:[NSNumber numberWithBool:NO] forKey:[NSNumber numberWithInteger:sender.tag]];
    }else{
        [selectedSectionDict setObject:[NSNumber numberWithBool:YES] forKey:[NSNumber numberWithInteger:sender.tag]];
    }
    
    [UIView animateWithDuration:0.9f delay:0.2 options:UIViewAnimationOptionCurveEaseOut animations:^{
        if (sender.isSelected) {
            sender.selected = NO;
        }else{
            sender.selected = YES;
        }
    } completion:^(BOOL finished) {
        if (finished) {
            [table reloadData];
            [table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:NSNotFound inSection:sender.tag] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        }
    }];
    
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

-(IBAction)applyButtonPressed:(UIButton*)sender{
    int row = (int)applyButton.tag;
    if(isWeeklySession){
        if (isChanged) {
            [self saveRateFitness];
        }
    }
   else if (isRateFitness){
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        if (![Utility isEmptyCheck:filterArray]) {
            [dict addEntriesFromDictionary:[filterArray objectAtIndex:0]];
            [dict setObject:[NSNumber numberWithInteger:row + 1] forKey:@"Value"];
            //        [self saveRateFitness];
            
            //ah 8.5
            if ([[[filterArray objectAtIndex:0] objectForKey:@"Value"] intValue] == 0) {
                [defaults setObject:[NSNumber numberWithInteger:row+1] forKey:@"FitnessRatingId"];  //ah 3.5
            } else {
                [defaults setObject:[[filterArray objectAtIndex:0] objectForKey:@"Value"] forKey:@"FitnessRatingId"];  //ah 3.5
            }
            [defaults synchronize];
            //end ah 8.5
            
            [self saveRateFitnessNewDict:[NSArray arrayWithObject:dict]];
        } else {
            [Utility msg:@"No data found" title:@"Error" controller:self haveToPop:NO];
        }
    }else{
        NSString *attributeName  = @"FlagCategory";
        NSString *attributeValue = @"Equipment";
        NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"(%K MATCHES %@)",attributeName,attributeValue];
        NSMutableArray *filterArray1 = [[responseObjArr filteredArrayUsingPredicate:predicate1] mutableCopy];
        
        if (filterArray1.count > 0) {
            for (int i = 0; i < filterArray1.count; i++) {
                NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
                [dict addEntriesFromDictionary:[filterArray1 objectAtIndex:i]];
                [dict setObject:[NSNumber numberWithInt:0] forKey:@"Value"];
                [filterArray1 removeObjectAtIndex:i];
                [filterArray1 insertObject:dict atIndex:i];
            }
            
            NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
            [dict addEntriesFromDictionary:[filterArray1 objectAtIndex:row]];
            [dict setObject:[NSNumber numberWithInt:1] forKey:@"Value"];
            [filterArray1 removeObjectAtIndex:row];
            [filterArray1 insertObject:dict atIndex:row];
            [self saveEquipmentWithData:filterArray1];
        } else {
            //            [Utility msg:@"Something went wrong. Please try again later." title:@"Error!" controller:self haveToPop:NO];
            [self updatedUserProgramSetupStepNo:5];
            RateFitnessLevelViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"RateFitnessLevel"];
            controller.isRateFitness = false;
            controller.isWeeklySession = true;
            [self.navigationController pushViewController:controller animated:YES];
        }
    }
}
#pragma -mark End
-(void)sizeHeaderToFit{
    UIView *headerView = table.tableHeaderView;
    
    [headerView setNeedsLayout];
    [headerView layoutIfNeeded];
    
    float height = [headerView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    CGRect frame = headerView.frame;
    frame.size.height = height;
    headerView.frame = frame;
    
    table.tableHeaderView = headerView;
}

-(void) showAlert {
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Oops"
                                          message:@"No fitness level preference found. Please select fitness level"
                                          preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:@"Confirm"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   RateFitnessLevelViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"RateFitnessLevel"];
                                   controller.isRateFitness = YES;
                                   [self.navigationController pushViewController:controller animated:YES];
                               }];
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:@"No"
                                   style:UIAlertActionStyleDestructive
                                   handler:^(UIAlertAction *action)
                                   {
                                       
                                   }];
    [alertController addAction:okAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
#pragma mark - Private Function

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
#pragma mark - End

#pragma mark - TableView Datasource & Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (isWeeklySession) {
        NSDictionary *sectionDict = [fitnessLevelArray objectAtIndex:section];
        if (![Utility isEmptyCheck:sectionDict]) {
            NSArray *sessionArray = [sectionDict objectForKey:@"recomendationDetails"];
            if (sessionArray.count > 0) {
                return UITableViewAutomaticDimension;
            }
        }
        return 0;
        
    }else{
        return 0;
    }
}

-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    RateFitnessLevelHeaderView *sectionHeaderView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:RateFitnessLevelHeaderViewIdentifier];
    NSDictionary *recomendetionDict = [fitnessLevelArray objectAtIndex:section];
    if ([[selectedSectionDict objectForKey:[NSNumber numberWithInteger:section]]boolValue]) {
        sectionHeaderView.expandCollapseButton.selected = YES;
    }else{
        sectionHeaderView.expandCollapseButton.selected = NO;
    }    sectionHeaderView.expandCollapseButton.tag = section;
    NSString *recomendationName = [recomendetionDict objectForKey:@"recomendationName"];
    if (![Utility isEmptyCheck:recomendationName]) {
        sectionHeaderView.sessionName.text = recomendationName;
        
    }
    [sectionHeaderView.expandCollapseButton addTarget:self
                                         action:@selector(sectionExpandCollapse:)
                               forControlEvents:UIControlEventTouchUpInside];
    return  sectionHeaderView;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (![Utility isEmptyCheck:fitnessLevelArray] && fitnessLevelArray.count > 0 && isWeeklySession) {
        return fitnessLevelArray.count;
    }
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (isWeeklySession) {
        NSDictionary *sectionDict = [fitnessLevelArray objectAtIndex:section];
        if (![Utility isEmptyCheck:sectionDict]) {
            NSArray *sessionArray = [sectionDict objectForKey:@"recomendationDetails"];
            if (sessionArray.count > 0) {
                if ([[selectedSectionDict objectForKey:[NSNumber numberWithInteger:section]]boolValue]) {
                    return 0;
                }else{
                    if (![Utility isEmptyCheck:sessionArray]) {
                        return sessionArray.count;
                    }
                    return 0;
                }
            }
        }
        return 0;

    } else if (isRateFitness) {
        return fitnessLevelArray.count;
    } else {
        return filterArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *CellIdentifier =@"ChooseGoalTableViewCell";
    ChooseGoalTableViewCell *cell = (ChooseGoalTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // Configure the cell...
    if (cell == nil) {
        cell = [[ChooseGoalTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.ratefitnessmainView.layer.borderColor = [Utility colorWithHexString:@"E425A0"].CGColor;
    cell.ratefitnessmainView.layer.borderWidth = 1;
    
    if (isWeeklySession) {
        NSDictionary *sectionDict = [fitnessLevelArray objectAtIndex:indexPath.section];
        if (![Utility isEmptyCheck:sectionDict]) {
            NSArray *sessionArray = [sectionDict objectForKey:@"recomendationDetails"];
            if (sessionArray.count > 0) {
                NSDictionary *dict =[sessionArray objectAtIndex:indexPath.row];
                if (![Utility isEmptyCheck:dict]) {
                    cell.goalName.textAlignment = NSTextAlignmentLeft;
                    cell.goalName.text = [Utility isEmptyCheck:[dict objectForKey:@"sessionName"]] ?@"": [dict objectForKey:@"sessionName"];
                    if ([[dict objectForKey:@"isdropdown"] boolValue]) {
                        cell.arrowButtonWidhConstraint.constant = 30;
                    }else{
                        cell.arrowButtonWidhConstraint.constant = 0;
                    }
                    if (responseObjDict.count > 0) {
                        if (indexPath.section == 0 && (int)indexPath.row == [[responseObjDict objectForKey:@"ExercisePlanId"] intValue] - 1 && selectIndexForWeeklySessionForSectonOne == -1) {
//                            [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
                            cell.ratefitnessmainView.layer.backgroundColor = [Utility colorWithHexString:@"E425A0"].CGColor;
                            cell.goalName.textColor = [UIColor whiteColor];
                            [self applyButtonFunction:YES];
                            nextButton.hidden = false;
                        } else if (indexPath.section == 1 && (int)indexPath.row == [[responseObjDict objectForKey:@"FBWCount"] intValue] - 1 && selectIndexForWeeklySessionForSectontwo == -1) {
//                            [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
                            cell.ratefitnessmainView.layer.backgroundColor = [Utility colorWithHexString:@"E425A0"].CGColor;
                            cell.goalName.textColor = [UIColor whiteColor];
                            [self applyButtonFunction:YES];
                            nextButton.hidden = false;
                        }else{
                            if (selectIndexForWeeklySessionForSectonOne == indexPath.row && indexPath.section == 0) {
                                cell.ratefitnessmainView.layer.backgroundColor = [Utility colorWithHexString:@"E425A0"].CGColor;
                                cell.goalName.textColor = [UIColor whiteColor];
                            }else if(selectIndexForWeeklySessionForSectontwo == indexPath.row && indexPath.section == 1 ){
                                cell.ratefitnessmainView.layer.backgroundColor = [Utility colorWithHexString:@"E425A0"].CGColor;
                                cell.goalName.textColor = [UIColor whiteColor];
                            }else{
                                cell.ratefitnessmainView.layer.backgroundColor = [UIColor whiteColor].CGColor;
                                cell.goalName.textColor = [Utility colorWithHexString:@"E425A0"];
                            }
                        }
                        if (selectIndexForWeeklySessionForSectonOne!=-1 && selectIndexForWeeklySessionForSectontwo!=-1){
                            [self applyButtonFunction:YES];
                        }
                    }else{
                        cell.ratefitnessmainView.layer.backgroundColor = [UIColor whiteColor].CGColor;
                        cell.goalName.textColor = [Utility colorWithHexString:@"E425A0"];
                    }
                }
            }
        }
        
    }else{
        NSDictionary *dict = [fitnessLevelArray objectAtIndex:indexPath.row];
        if (![Utility isEmptyCheck:dict]) {
            if (isRateFitness) {
                cell.goalName.textAlignment = NSTextAlignmentLeft;
                cell.goalName.text = [Utility isEmptyCheck:[dict objectForKey:@"fitnessLevel"]] ?@"": [dict objectForKey:@"fitnessLevel"];
                //                if (responseObjDict.count > 0) {
                //                    if ((int)indexPath.row == [[responseObjDict objectForKey:@"FitnessRatingId"] intValue] - 1) {
                //                        [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
                //                    }
                //                }
                
                if (![Utility isEmptyCheck:filterArray]) {
                    if (indexPath.row == [[[filterArray objectAtIndex:0] objectForKey:@"Value"] intValue]-1 && selectedIndex==-1) {
                        [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
                        nextButton.hidden = false;
                        
                        cell.ratefitnessmainView.layer.backgroundColor = [Utility colorWithHexString:@"E425A0"].CGColor;
                        cell.goalName.textColor = [UIColor whiteColor];
                        
                        [defaults setObject:[[filterArray objectAtIndex:0] objectForKey:@"Value"] forKey:@"FitnessRatingId"];
                        [defaults synchronize]; //ah 8.5
                        [self applyButtonFunction:YES];
                    }else{
                        if(selectedIndex == indexPath.row){
                            cell.ratefitnessmainView.layer.backgroundColor = [Utility colorWithHexString:@"E425A0"].CGColor;
                            cell.goalName.textColor = [UIColor whiteColor];
                            [self applyButtonFunction:YES];
                        }else{
                            cell.ratefitnessmainView.layer.backgroundColor = [UIColor whiteColor].CGColor;
                            cell.goalName.textColor = [Utility colorWithHexString:@"E425A0"];
                        }
                    }
                }
            } else{
                cell.goalName.textAlignment = NSTextAlignmentLeft;
                
                if (![Utility isEmptyCheck:filterArray] && [[[filterArray objectAtIndex:indexPath.row] objectForKey:@"FlagTitle"] caseInsensitiveCompare:@"Body Weight Only"] == NSOrderedSame) {
                    
                    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:[@"Body Weight Only" uppercaseString]];
                    [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Oswald-Regular" size:15] range:NSMakeRange(0, [attributedString length])];
                    [attributedString addAttribute:NSForegroundColorAttributeName value:[Utility colorWithHexString:@"E425A0"] range:NSMakeRange(0, [attributedString length])];
                    
                    NSMutableAttributedString *attributedString2 =[[NSMutableAttributedString alloc]initWithString:@"\n I don't have any access to fitness equipment and normally workout at home."];
                    [attributedString2 addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Oswald-Regular" size:12] range:NSMakeRange(0, [attributedString2 length])];
                    [attributedString2 addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, [attributedString2 length])];
                    
                    [attributedString appendAttributedString:attributedString2];
                    cell.goalName.attributedText = attributedString;
                    
                    
//                    cell.goalName.attributedText = [Utility convertString:@"Body Weight Only\nI don't have any access to fitness equipment and normally workout at home." ToMutableAttributedStringOfFont:@"Raleway" Size:13.0 WithRangeString:@"Body Weight Only" RangeFont:@"Raleway-Bold" Size:13.0];
                    
                } else if (![Utility isEmptyCheck:filterArray] && [[[filterArray objectAtIndex:indexPath.row] objectForKey:@"FlagTitle"] caseInsensitiveCompare:@"Squad Straps"] == NSOrderedSame) {
                    
                    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:[@"Squad Straps" uppercaseString]];
                    [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Oswald-Regular" size:15] range:NSMakeRange(0, [attributedString length])];
                    [attributedString addAttribute:NSForegroundColorAttributeName value:[Utility colorWithHexString:@"E425A0"] range:NSMakeRange(0, [attributedString length])];
                    
                    
                    NSMutableAttributedString *attributedString2 =[[NSMutableAttributedString alloc]initWithString:@"\nI have a set of Squad Straps or TRX."];
                    [attributedString2 addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Oswald-Regular" size:12] range:NSMakeRange(0, [attributedString2 length])];
                    [attributedString2 addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, [attributedString2 length])];
                    
                    
                    [attributedString appendAttributedString:attributedString2];
                    cell.goalName.attributedText = attributedString;
                    
//                    cell.goalName.attributedText = [Utility convertString:@"Squad Straps\nI have a set of Squad Straps or TRX." ToMutableAttributedStringOfFont:@"Raleway" Size:13.0 WithRangeString:@"Squad Straps" RangeFont:@"Raleway-Bold" Size:13.0];

                } else if (![Utility isEmptyCheck:filterArray] && [[[filterArray objectAtIndex:indexPath.row] objectForKey:@"FlagTitle"] caseInsensitiveCompare:@"Gym"] == NSOrderedSame) {
                    
                    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:[@"I have a Gym Membership" uppercaseString]];
                    [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Oswald-Regular" size:15] range:NSMakeRange(0, [attributedString length])];
                    [attributedString addAttribute:NSForegroundColorAttributeName value:[Utility colorWithHexString:@"E425A0"] range:NSMakeRange(0, [attributedString length])];
                    
                    
                    NSMutableAttributedString *attributedString2 =[[NSMutableAttributedString alloc]initWithString:@"\nI have access to weights and a range of fitness equipment."];
                    [attributedString2 addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Oswald-Regular" size:12] range:NSMakeRange(0, [attributedString2 length])];
                    [attributedString2 addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, [attributedString2 length])];
                    
                    
                    [attributedString appendAttributedString:attributedString2];
                    cell.goalName.attributedText = attributedString;
//                    cell.goalName.attributedText = [Utility convertString:@"I have a Gym Membership\nI have access to weights and a range of fitness equipment." ToMutableAttributedStringOfFont:@"Raleway" Size:13.0 WithRangeString:@"I have a Gym Membership" RangeFont:@"Raleway-Bold" Size:13.0];
                }
                if (![Utility isEmptyCheck:filterArray] && [[[filterArray objectAtIndex:indexPath.row] objectForKey:@"Value"] boolValue] && selectedIndex == -1) {
                    [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
                    nextButton.hidden = false;
                    
                    cell.ratefitnessmainView.layer.backgroundColor = [Utility colorWithHexString:@"E425A0"].CGColor;
                    cell.goalName.textColor = [UIColor whiteColor];
                    
                    [self applyButtonFunction:YES];
                }else{
                    if(selectedIndex == indexPath.row){
                        cell.ratefitnessmainView.layer.backgroundColor = [Utility colorWithHexString:@"E425A0"].CGColor;
                        cell.goalName.textColor = [UIColor whiteColor];
                        [self applyButtonFunction:YES];
                    }else{
                        cell.ratefitnessmainView.layer.backgroundColor = [UIColor whiteColor].CGColor;
                        cell.goalName.textColor = [Utility colorWithHexString:@"E425A0"];
                    }
                }
                if ([[dict objectForKey:@"isdropdown"] boolValue]) {
                    cell.arrowButtonWidhConstraint.constant = 30;
                }else{
                    cell.arrowButtonWidhConstraint.constant = 0;
                }
            }
        }
    }
    
//    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
//    cell.goalName.highlightedTextColor = [UIColor whiteColor];
    return cell;
}
- (NSIndexPath*)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath*)indexPath {
    for ( NSIndexPath* selectedIndexPath in tableView.indexPathsForSelectedRows ) {
        if ( selectedIndexPath.section == indexPath.section )
            [tableView deselectRowAtIndexPath:selectedIndexPath animated:NO] ;
    }
    return indexPath ;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (isWeeklySession){
        if (indexPath.section == 0) {
//            for ( NSIndexPath* selectedIndexPath in tableView.indexPathsForSelectedRows ) {
//                if ( selectedIndexPath.section != indexPath.section )
//                    nextButton.hidden = false;
//            }
            [responseObjDict removeObjectForKey:@"ExercisePlanId"];
            [responseObjDict setObject:[NSNumber numberWithInteger:(int)indexPath.row + 1] forKey:@"ExercisePlanId"];
        } else if (indexPath.section == 1) {
//            for ( NSIndexPath* selectedIndexPath in tableView.indexPathsForSelectedRows ) {
//                if ( selectedIndexPath.section != indexPath.section )
//                    nextButton.hidden = false;
//            }
            [responseObjDict removeObjectForKey:@"FBWCount"];
            [responseObjDict setObject:[NSNumber numberWithInteger:(int)indexPath.row + 1] forKey:@"FBWCount"];
            
        }
        isChanged = YES;
    }
    applyButton.tag=indexPath.row;
    applyButton.accessibilityHint = [@"" stringByAppendingFormat:@"%ld",(long)indexPath.section];
    selectedIndex = indexPath.row;
    if (isWeeklySession) {
        if (indexPath.section == 0) {
            selectIndexForWeeklySessionForSectonOne = indexPath.row;
        }
        if (indexPath.section == 1) {
            selectIndexForWeeklySessionForSectontwo = indexPath.row;
        }
    }
    
    [table reloadData];
    /*
    if (isWeeklySession){
        if (indexPath.section == 0) {
            for ( NSIndexPath* selectedIndexPath in tableView.indexPathsForSelectedRows ) {
                if ( selectedIndexPath.section != indexPath.section )
                    nextButton.hidden = false;
            }
            [responseObjDict removeObjectForKey:@"ExercisePlanId"];
            [responseObjDict setObject:[NSNumber numberWithInteger:(int)indexPath.row + 1] forKey:@"ExercisePlanId"];
        } else if (indexPath.section == 1) {
            for ( NSIndexPath* selectedIndexPath in tableView.indexPathsForSelectedRows ) {
                if ( selectedIndexPath.section != indexPath.section )
                    nextButton.hidden = false;
            }
            [responseObjDict removeObjectForKey:@"FBWCount"];
            [responseObjDict setObject:[NSNumber numberWithInteger:(int)indexPath.row + 1] forKey:@"FBWCount"];
            
        }
        isChanged = YES;
    }else if (isRateFitness){
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        if (![Utility isEmptyCheck:filterArray]) {
            [dict addEntriesFromDictionary:[filterArray objectAtIndex:0]];
            [dict setObject:[NSNumber numberWithInteger:indexPath.row + 1] forKey:@"Value"];
            //        [self saveRateFitness];
            
            //ah 8.5
            if ([[[filterArray objectAtIndex:0] objectForKey:@"Value"] intValue] == 0) {
                [defaults setObject:[NSNumber numberWithInteger:indexPath.row+1] forKey:@"FitnessRatingId"];  //ah 3.5
            } else {
                [defaults setObject:[[filterArray objectAtIndex:0] objectForKey:@"Value"] forKey:@"FitnessRatingId"];  //ah 3.5
            }
            [defaults synchronize];
            //end ah 8.5
            
            [self saveRateFitnessNewDict:[NSArray arrayWithObject:dict]];
        } else {
            [Utility msg:@"No data found" title:@"Error" controller:self haveToPop:NO];
        }
    }else{
        NSString *attributeName  = @"FlagCategory";
        NSString *attributeValue = @"Equipment";
        NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"(%K MATCHES %@)",attributeName,attributeValue];
        NSMutableArray *filterArray1 = [[responseObjArr filteredArrayUsingPredicate:predicate1] mutableCopy];
        
        if (filterArray1.count > 0) {
            for (int i = 0; i < filterArray1.count; i++) {
                NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
                [dict addEntriesFromDictionary:[filterArray1 objectAtIndex:i]];
                [dict setObject:[NSNumber numberWithInt:0] forKey:@"Value"];
                [filterArray1 removeObjectAtIndex:i];
                [filterArray1 insertObject:dict atIndex:i];
            }
            
            NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
            [dict addEntriesFromDictionary:[filterArray1 objectAtIndex:indexPath.row]];
            [dict setObject:[NSNumber numberWithInt:1] forKey:@"Value"];
            [filterArray1 removeObjectAtIndex:indexPath.row];
            [filterArray1 insertObject:dict atIndex:indexPath.row];
            [self saveEquipmentWithData:filterArray1];
        } else {
//            [Utility msg:@"Something went wrong. Please try again later." title:@"Error!" controller:self haveToPop:NO];
            [self updatedUserProgramSetupStepNo:5];
            RateFitnessLevelViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"RateFitnessLevel"];
            controller.isRateFitness = false;
            controller.isWeeklySession = true;
            [self.navigationController pushViewController:controller animated:YES];
        }
    }
     */
}

#pragma -mark End

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
