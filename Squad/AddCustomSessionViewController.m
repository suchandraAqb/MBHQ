//
//  AddCustomSessionViewController.m
//  Squad
//
//  Created by AQB SOLUTIONS on 06/04/2017.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import "AddCustomSessionViewController.h"
#import "Utility.h"
#import "ExerciseDetailsViewController.h"
#import "SessionListViewController.h"

@interface AddCustomSessionViewController ()<SessionListDelegate> {
    IBOutlet UIButton *sessionCategoryButton;
    IBOutlet UIView *sessionTypeView;
    IBOutlet UIButton *sessionTypeButton;
    IBOutlet UIView *sessionNameView;
    IBOutlet UIButton *sessionNameButton;
    IBOutlet UIStackView *sessionDetailStackView;
    IBOutlet UIButton *personalizeSessionButton;
    IBOutlet UIButton *viewSessionButton;
    IBOutlet UIButton *saveButton;
    IBOutlet UIView *buttonView;
    
    NSMutableArray *sessionCategoryArray;
    NSMutableArray *sessionTypeArray;
    NSMutableArray *sessionDetailsArray;

    UIView *contentView;
    NSString *startDateTime;
    NSString *startDateTimeStr;
    int workoutTypeId;
    BOOL isChanged;
    BOOL autoSave;
}

@end
//ah aec
@implementation AddCustomSessionViewController
@synthesize AddCustomSessionViewDelegate,sessionID,sessionDate1;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    autoSave = false;
    sessionCategoryArray = [[NSMutableArray alloc] init];
    sessionTypeArray = [[NSMutableArray alloc] init];
    sessionDetailsArray = [[NSMutableArray alloc] init];

    personalizeSessionButton.layer.cornerRadius = 5;
    viewSessionButton.layer.cornerRadius = 5;
    saveButton.layer.cornerRadius = 5;
    personalizeSessionButton.clipsToBounds = YES;
    viewSessionButton.clipsToBounds = YES;
    saveButton.clipsToBounds = YES;
    
    UIImage *ddImage = [UIImage imageNamed:@"dropdown_arrow.png"];
    sessionCategoryButton.imageEdgeInsets = UIEdgeInsetsMake(0., sessionCategoryButton.frame.size.width - (ddImage.size.width + 15.), 0., 0.);
    sessionCategoryButton.titleEdgeInsets = UIEdgeInsetsMake(0., 0., 0., ddImage.size.width);
    [sessionCategoryButton setAccessibilityHint:@"0"];
    
    sessionTypeButton.imageEdgeInsets = UIEdgeInsetsMake(0., sessionCategoryButton.frame.size.width - (ddImage.size.width + 15.), 0., 0.);
    sessionTypeButton.titleEdgeInsets = UIEdgeInsetsMake(0., 0., 0., ddImage.size.width);
    [sessionTypeButton setAccessibilityHint:@"0"];

    sessionNameButton.imageEdgeInsets = UIEdgeInsetsMake(0., sessionCategoryButton.frame.size.width - (ddImage.size.width + 15.), 0., 0.);
    sessionNameButton.titleEdgeInsets = UIEdgeInsetsMake(0., 0., 0., ddImage.size.width);
    [sessionNameButton setAccessibilityHint:@"0"];

    sessionTypeView.hidden = true;
    sessionNameView.hidden = true;
    buttonView.hidden = true;
    viewSessionButton.hidden = true;
    personalizeSessionButton.hidden = true;
    
    if (sessionID && sessionID > 0) {
        //edit
        [self getSquadUserWorkoutSession];
    } //ah se
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    sessionCategoryArray = [@[
                              @{
                                  @"name" : @"--Select a Session Category--",
                                  @"id" :   @0
                                  },
                              @{
                                  @"name" : @"Squad Custom Sessions",
                                  @"id" :   @1
                                  },
                              @{
                                  @"name" : @"FBW",
                                  @"id" : @5
                                  },
                              @{
                                  @"name" : @"Session I Designed",
                                  @"id" : @4
                                  },
                              @{
                                  @"name" : @"Sport",
                                  @"id" : @3
                                  },
                              @{
                                  @"name" : @"Class/Activity I Attend",
                                  @"id" : @2
                                  }
                              ] mutableCopy];
    
    sessionTypeArray = [@[
                          @{
                              @"name" : @"--Select a Session Type--",
                              @"id" :   @0
                              },
                          @{
                              @"name" : @"Weights",
                              @"id" :   @1
                              },
                          @{
                              @"name" : @"HIIT Session",
                              @"id" : @2
                              },
                          @{
                              @"name" : @"Pilates/Core",
                              @"id" : @3
                              },
                          @{
                              @"name" : @"Yoga",
                              @"id" : @4
                              },
                          @{
                              @"name" : @"Cardio",
                              @"id" : @5
                              }
                          ] mutableCopy];   //ah 2.5
    
    /*
     ,
     @{
     @"name" : @"Cardio Based Class",
     @"id" : @6
     },
     @{
     @"name" : @"Resistance Based Class",
     @"id" : @7
     }
     */
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction
-(IBAction)homeButtonPressed:(UIButton*)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(IBAction)backButtonPressed:(id)sender{
    if (isChanged) {
        if ([AddCustomSessionViewDelegate respondsToSelector:@selector(getUpdateSessionId:)]) {
            [AddCustomSessionViewDelegate getUpdateSessionId:(int)_exerciseSessionId]; //Feedback - 28032018
        }
    }
    if ([AddCustomSessionViewDelegate respondsToSelector:@selector(didCheckAnyChange:)]) {
        [AddCustomSessionViewDelegate didCheckAnyChange:isChanged]; //Feedback - 28032018
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)infoButtonPressed:(UIButton *)sender {//feedback info button
    NSString *urlString=@"https://player.vimeo.com/external/290408476.m3u8?s=67c64bb18f175a8b9899f2350d9d9f81b5f39cad";
    [Utility showHelpAlertWithURL:urlString controller:self haveToPop:NO];
}

- (IBAction)dropDownButtonTapped:(UIButton *)sender {
    int selectedIndex = -1;
    NSArray *dropdownDataArray = [[NSArray alloc] init];
    NSString *apiType = @"";
    NSLog(@"acc %@",sender.accessibilityHint);
    switch (sender.tag) {
        case 1:
            dropdownDataArray = sessionCategoryArray;
            apiType = @"SessionCategory";
            if (![Utility isEmptyCheck:sender.accessibilityHint]) {
                NSDictionary *dict = [self getDictByValue:sessionCategoryArray intValue:[sender.accessibilityHint intValue] type:@"id"];
                selectedIndex = (int)[sessionCategoryArray indexOfObject:dict];
            }
            break;
            
        case 2:
            dropdownDataArray = sessionTypeArray;
            apiType = @"SessionType";
            if (![Utility isEmptyCheck:sender.accessibilityHint]) {
                NSDictionary *dict = [self getDictByValue:sessionTypeArray intValue:[sender.accessibilityHint intValue] type:@"id"];
                selectedIndex = (int)[sessionTypeArray indexOfObject:dict];
            }
            break;
            
        case 3:
            if (![Utility isEmptyCheck:sessionDetailsArray]) {
                dropdownDataArray = sessionDetailsArray;
            }
            apiType = @"SessionDetails";
            if (![Utility isEmptyCheck:sender.accessibilityHint] && ![Utility isEmptyCheck:sessionDetailsArray]) {
                NSDictionary *dict = [self getDictByValue:sessionDetailsArray intValue:[sender.accessibilityHint intValue] type:@"ExerciseSessionId"];
                selectedIndex = (int)[sessionDetailsArray indexOfObject:dict];
            }
            break;
            
        default:
            break;
    }
    DropdownViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Dropdown"];
    controller.modalPresentationStyle = UIModalPresentationCustom;
    controller.dropdownDataArray = dropdownDataArray;
    controller.mainKey = @"name";
    if (sender.tag == 3) {
        controller.mainKey = @"SessionTitle";
    }
    controller.apiType = apiType;
    controller.selectedIndex = selectedIndex;
    controller.shouldScrollToIndexpath = YES;   //ah se
    controller.delegate = self;
    [self presentViewController:controller animated:YES completion:nil];
}
- (IBAction)personalizeButtonTapped:(id)sender {    //ah edit    
    EditExerciseSessionViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"EditExerciseSession"];
    controller.exSessionId = [sessionNameButton.accessibilityHint intValue];    //4227;// 3250;//4057;
    controller.dt = sessionDate1;
    controller.personalizedSessionDelegate = self;
    [self presentViewController:controller animated:YES completion:nil];
}
- (IBAction)viewSessionButtonTapped:(id)sender {
    
    if(_isFromExerciseDetails){
        [self backButtonPressed:0];
        return;
    }
    
    ExerciseDetailsViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ExerciseDetails"];
    controller.exSessionId = [sessionNameButton.accessibilityHint intValue];
    controller.sessionDate = sessionDate1;
    controller.weekDate = _weekDate; //AY 07112017
    controller.fromWhere =@"customSession"; //AY 07112017
    controller.workoutTypeId = workoutTypeId; //AY 07112017
    controller.isEditSession = true;
    [self.navigationController pushViewController:controller animated:YES];
}
- (IBAction)saveButtonTapped:(id)sender {
    if ([self isFormValidated]) {
        [self saveSession:YES];
    }
}
#pragma mark - API Call
-(void) getSquadUserWorkoutSession {
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
        [mainDict setObject:[NSNumber numberWithInteger:sessionID] forKey:@"Id"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetSquadWorkoutSession" append:@""forAction:@"POST"];
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
                                                                         
                                                                         NSDictionary *workoutDict = [responseDict objectForKey:@"SquadUserWorkoutSession"];
                                                                         workoutTypeId = [[workoutDict objectForKey:@"Id"] intValue];
                                                                         
                                                                         NSMutableDictionary *exerciseSessionDetails = [[NSMutableDictionary alloc] init];
                                                                         exerciseSessionDetails = [[responseDict objectForKey:@"SquadUserWorkoutSession"] objectForKey:@"ExerciseSessionDetails"];
                                                                         
                                                                         NSDictionary *dict = [self getDictByValue:sessionCategoryArray intValue:[[exerciseSessionDetails objectForKey:@"SessionCategory"] intValue] type:@"id"];
                                                                         [sessionCategoryButton setTitle:[dict objectForKey:@"name"] forState:UIControlStateNormal];
                                                                         [sessionCategoryButton setAccessibilityHint:[[exerciseSessionDetails objectForKey:@"SessionCategory"] stringValue]];
                                                                         
                                                                         NSDictionary *dict1 = [self getDictByValue:sessionTypeArray intValue:[[exerciseSessionDetails objectForKey:@"SessionType"] intValue] type:@"id"];
                                                                         [sessionTypeButton setTitle:[dict1 objectForKey:@"name"] forState:UIControlStateNormal];
                                                                         [sessionTypeButton setAccessibilityHint:[[exerciseSessionDetails objectForKey:@"SessionType"] stringValue]];
                                                                         
                                                                         [sessionNameButton setTitle:[exerciseSessionDetails objectForKey:@"SessionTitle"] forState:UIControlStateNormal];
                                                                         [sessionNameButton setAccessibilityHint:[[exerciseSessionDetails objectForKey:@"Id"] stringValue]];
                                                                         
                                                                         sessionNameView.hidden = false;
                                                                         buttonView.hidden = false;
                                                                         
                                                                         if ([[exerciseSessionDetails objectForKey:@"SessionCategory"] intValue] == 2 || [[exerciseSessionDetails objectForKey:@"SessionCategory"] intValue] == 3 || [[exerciseSessionDetails objectForKey:@"SessionCategory"] intValue] == 5) {
                                                                             sessionTypeView.hidden = true;
                                                                             
                                                                         } else {
                                                                             sessionTypeView.hidden = false;
                                                                         }
                                                                         
                                                                         startDateTime = [[responseDict objectForKey:@"SquadUserWorkoutSession"] objectForKey:@"StartDateTime"];
                                                                         
                                                                         startDateTimeStr = [[responseDict objectForKey:@"SquadUserWorkoutSession"] objectForKey:@"StartDateTimeStr"];
                                                                         
                                                                         viewSessionButton.hidden = true;
                                                                         personalizeSessionButton.hidden = true;   //ah edit
                                                                         
                                                                         
                                                                         
                                                                         if ([sessionCategoryButton.accessibilityHint intValue] == 1 || [sessionCategoryButton.accessibilityHint intValue] == 4) {
                                                                             personalizeSessionButton.hidden = false;
                                                                             viewSessionButton.hidden = false;
                                                                         }
                                                                         
                                                                         
                                                                         int sessionFlowId = [[exerciseSessionDetails objectForKey:@"SessionFlowId"] intValue];
                                                                         if(sessionFlowId == TIMER || sessionFlowId == CIRCUITTIMER || sessionFlowId == FOLLOWALONG){
                                                                             personalizeSessionButton.hidden = true;
                                                                         }
                                                                         
                                                                         [self getSessionList];
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
-(void) getSessionList {
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (contentView) {
                [contentView removeFromSuperview];
            }
            contentView = [Utility activityIndicatorView:self];
        });
        
        int category = 1;
        int sessionTypeId = 1;
        int sessionFlowId = 2;
        for (int i = 1; i <= 2; i++) {
            UIButton *button = (UIButton *)[self.view viewWithTag:i];
            if ([button isKindOfClass:[UIButton class]]) {
                if (![Utility isEmptyCheck:button.accessibilityHint]) {
                    switch (i) {
                        case 1:
                            category = [button.accessibilityHint intValue];
                            break;
                           
                        case 2:
                            sessionTypeId = [button.accessibilityHint intValue];
                            break;
                            
                        default:
                            break;
                    }
                }
            }
        }
        
        NSString *append;
        
        if (category == 2 || category == 3 || category == 5 || sessionTypeId == 0) {    //ah 2.5
            append = [NSString stringWithFormat:@"?userId=%d&category=%d&sessionTypeId=null&sessionFlowId=%d&isSquadSession=true",[[defaults objectForKey:@"ABBBCOnlineUserId"] intValue],category,sessionFlowId];  //ah se
        } else {
            append = [NSString stringWithFormat:@"?userId=%d&category=%d&sessionTypeId=%d&sessionFlowId=%d&isSquadSession=true",[[defaults objectForKey:@"ABBBCOnlineUserId"] intValue],category,sessionTypeId,sessionFlowId];  //ah se
        }
        
        NSMutableURLRequest *request = [Utility getRequest:@"" api:@"GetSquadExerciseSessions" append:append forAction:@"GET"];
        
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 if (contentView){
                                                                     [contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"]boolValue]) {
                                                                         sessionDetailsArray = [responseDict objectForKey:@"obj"];
                                                                         if (autoSave) {
                                                                             NSDictionary *temp = [sessionDetailsArray objectAtIndex:0];
                                                                             if([temp[@"SessionTitle"] caseInsensitiveCompare:@"FBW"] == NSOrderedSame){
                                                                                 [sessionNameButton setTitle:[temp objectForKey:@"SessionTitle"] forState:UIControlStateNormal];
                                                                                 [sessionNameButton setAccessibilityHint:[[temp objectForKey:@"ExerciseSessionId"] stringValue]];
                                                                                 personalizeSessionButton.hidden = true;
                                                                                 viewSessionButton.hidden = true;
                                                                                 
                                                                                 [self saveButtonTapped:0];
                                                                             }
                                                                         }
                                                                     }
                                                                     else{
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

- (void) saveSession:(BOOL)isPop {
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
            self->contentView = [Utility activityIndicatorView:self];
        });
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSError *error;
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
        
        NSDateFormatter *formatterStr = [[NSDateFormatter alloc] init];
        [formatterStr setDateFormat:@"yyyy-MM-dd"];
        
        NSMutableDictionary *dict1 = [[NSMutableDictionary alloc] init];
        [dict1 setObject:sessionNameButton.accessibilityHint forKey:@"Id"];
        [dict1 setObject:[sessionNameButton titleForState:UIControlStateNormal] forKey:@"SessionTitle"];
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
        if (sessionID && sessionID > 0) {
            [dict setObject:[NSNumber numberWithInteger:sessionID] forKey:@"Id"];
            [dict setObject:startDateTime forKey:@"StartDateTime"];
            [dict setObject:startDateTimeStr forKey:@"StartDateTimeStr"];
        }else {
            [dict setObject:[NSNumber numberWithInteger:0] forKey:@"Id"];
            [dict setObject:[formatter stringFromDate:_sessionDate] forKey:@"StartDateTime"];
            [dict setObject:[formatterStr stringFromDate:_sessionDate] forKey:@"StartDateTimeStr"];
        }
        [dict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [dict setObject:sessionNameButton.accessibilityHint forKey:@"ExerciseSessionId"];
        [dict setObject:sessionTypeButton.accessibilityHint forKey:@"SessionTypeId"];
        [dict setObject:[NSNumber numberWithBool:0] forKey:@"IsSystemGenerated"];
        [dict setObject:[NSNumber numberWithBool:0] forKey:@"RepeatNextWeek"];
        [dict setObject:[NSNumber numberWithBool:0] forKey:@"IsDone"];
        [dict setObject:[NSNumber numberWithInteger:1] forKey:@"OrderNumber"];
        [dict setObject:[formatter stringFromDate:[NSDate date]] forKey:@"DateUpdated"];
        //        [dict setObject:dict1 forKey:@"ExerciseSessionDetails"];
        
        
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        [mainDict setObject:[NSNumber numberWithInteger:1] forKey:@"StepNo"];
        [mainDict setObject:dict forKey:@"model"];
        
        
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"AddUpdateSquadUserWorkoutSession" append:@"" forAction:@"POST"];
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
                                                                         isChanged = true;
                                                                         [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateBadgePoint" object:self];//gami_badge_popup_train

                                                                       //Feedback - 28032018
                                                                         _exerciseSessionId = [[[responseDict objectForKey:@"SquadUserWorkoutSession"]objectForKey:@"ExerciseSessionId"]intValue];
                                                                         if(isPop){
                                                                             if ([AddCustomSessionViewDelegate respondsToSelector:@selector(getUpdateSessionId:)]) {
                                                                                 [AddCustomSessionViewDelegate getUpdateSessionId:(int)_exerciseSessionId];
                                                                             }
                                                                             if ([AddCustomSessionViewDelegate respondsToSelector:@selector(didCheckAnyChange:)]) {
                                                                                 [AddCustomSessionViewDelegate didCheckAnyChange:isChanged];
                                                                             }
                                                                             [self.navigationController popViewControllerAnimated:YES];
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
#pragma mark - Dropdown Delegate
- (void) didSelectAnyDropdownOption:(NSString *)type data:(NSDictionary *)selectedData{
//    NSLog(@"ty %@ \ndata %@",type,selectedData);
    autoSave = false;
    
    if ([type caseInsensitiveCompare:@"SessionCategory"] == NSOrderedSame) {
        [sessionCategoryButton setTitle:[selectedData objectForKey:@"name"] forState:UIControlStateNormal];
        [sessionCategoryButton setAccessibilityHint:[[selectedData objectForKey:@"id"] stringValue]];
        switch ([[selectedData objectForKey:@"id"] intValue]) {
            case 1:
                sessionTypeView.hidden = false;
                sessionNameView.hidden = true;
                buttonView.hidden = true;
                [self gotoSessionList:false];
                break;
              
            case 2:
                sessionTypeView.hidden = true;
                sessionNameView.hidden = false;
                buttonView.hidden = false;
                [self getSessionList];
                break;
                
            case 3:
                sessionTypeView.hidden = true;
                sessionNameView.hidden = false;
                buttonView.hidden = false;
                [self getSessionList];
                break;
                
            case 4:
                sessionTypeView.hidden = false;
                sessionNameView.hidden = false;
                buttonView.hidden = false;  //ah 2.5
                [self getSessionList];
                [self gotoSessionList:true];
                break;
                
            case 5:
                sessionTypeView.hidden = true;
                sessionNameView.hidden = false;
                buttonView.hidden = false;
                autoSave = true;
                [self getSessionList];
                break;
                
            default:
                break;
        }
        [sessionTypeButton setTitle:@"--Select a Session Type--" forState:UIControlStateNormal];
        [sessionNameButton setTitle:@"--Select a Exercise Sessions--" forState:UIControlStateNormal];
        [sessionTypeButton setAccessibilityHint:@"0"];
        [sessionNameButton setAccessibilityHint:@"0"];
        
    } else if ([type caseInsensitiveCompare:@"SessionType"] == NSOrderedSame) {
        [self populateSessionType:selectedData];
    } else if ([type caseInsensitiveCompare:@"SessionDetails"] == NSOrderedSame) {
        [self populateSessionDetails:selectedData];
    }
    
    
}
#pragma mark - PersonalizedSessionDelegate
- (void) getSelectedSessionName:(NSString *)name Id:(NSString *)sessionIDStr{
    [sessionNameButton setTitle:name forState:UIControlStateNormal];
    [sessionNameButton setAccessibilityHint:sessionIDStr];
    [self getSessionList];
//    [self saveSession:NO];
}
#pragma mark - Private Methods
-(NSDictionary *)getDictByValue:(NSArray *)filterArray intValue:(int)value type:(NSString *)type{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(%K == %d)",type, value];
    NSArray *filteredSessionCategoryArray = [filterArray filteredArrayUsingPredicate:predicate];
    if (filteredSessionCategoryArray.count > 0) {
        NSDictionary *dict = [filteredSessionCategoryArray objectAtIndex:0];
        return dict;
    }
    return  nil;
}

-(BOOL) isFormValidated {
    if ([sessionCategoryButton.accessibilityHint intValue] == 0) {
        [Utility msg:@"Please select Session Category" title:@"Error" controller:self haveToPop:NO];
        return false;
    } else if ([sessionTypeButton.accessibilityHint intValue] == 0 && !sessionTypeView.isHidden && [sessionCategoryButton.accessibilityHint intValue] != 4) {   //ah 2.5
        [Utility msg:@"Please select Session Type" title:@"Error" controller:self haveToPop:NO];
        return false;
    } else if ([sessionNameButton.accessibilityHint intValue] == 0) {
        [Utility msg:@"Please select Session Name" title:@"Error" controller:self haveToPop:NO];
        return false;
    }
    
    return true;
}
-(void)gotoSessionList:(BOOL)isMySession{
    SessionListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SessionList"];
    controller.isFromAddEditSession = true;
    controller.isMySessionSelected = isMySession;
    controller.delegate = self;
    [self.navigationController pushViewController:controller animated:NO];
}

-(void)populateSessionType:(NSDictionary *)selectedData{
    [sessionTypeButton setTitle:[selectedData objectForKey:@"name"] forState:UIControlStateNormal];
    [sessionTypeButton setAccessibilityHint:[[selectedData objectForKey:@"id"] stringValue]];
    sessionNameView.hidden = false;
    buttonView.hidden = false;
    [sessionNameButton setTitle:@"--Select a Exercise Sessions--" forState:UIControlStateNormal];
    [sessionNameButton setAccessibilityHint:@"0"];
    [self getSessionList];
}

-(void)populateSessionDetails:(NSDictionary *)selectedData{
    
    [sessionNameButton setTitle:[selectedData objectForKey:@"SessionTitle"] forState:UIControlStateNormal];
    [sessionNameButton setAccessibilityHint:[[selectedData objectForKey:@"ExerciseSessionId"] stringValue]];
    personalizeSessionButton.hidden = true;
    viewSessionButton.hidden = true;
    
    if ([sessionCategoryButton.accessibilityHint intValue] == 1 || [sessionCategoryButton.accessibilityHint intValue] == 4) {   //ah edit
        personalizeSessionButton.hidden = false;
        viewSessionButton.hidden = false;
    }
    
    int sessionFlowId = [[selectedData objectForKey:@"SessionFlowId"] intValue];
    if(sessionFlowId == TIMER || sessionFlowId == CIRCUITTIMER || sessionFlowId == FOLLOWALONG){
        personalizeSessionButton.hidden = true;
    }
    
}
#pragma mark - End
#pragma mark - SessionList Delegate
-(void)didSelectSession:(NSDictionary *)dataDict{
    NSLog(@"Selected Session:%@",dataDict.debugDescription);
    
    NSString *workoutType = [dataDict objectForKey:@"WorkoutType"];
    NSDictionary *sessionTypeDict;
    if([workoutType caseInsensitiveCompare:@"Weights"] == NSOrderedSame){
        sessionTypeDict = sessionTypeArray[1];
    }else if([workoutType caseInsensitiveCompare:@"HIIT"] == NSOrderedSame){
        sessionTypeDict = sessionTypeArray[2];
    }else if([workoutType caseInsensitiveCompare:@"Pilates"] == NSOrderedSame){
        sessionTypeDict = sessionTypeArray[3];
    }else if([workoutType caseInsensitiveCompare:@"Yoga"] == NSOrderedSame){
        sessionTypeDict = sessionTypeArray[4];
    }else if([workoutType caseInsensitiveCompare:@"Cardio"] == NSOrderedSame){
        sessionTypeDict = sessionTypeArray[5];
    }
    
    [self populateSessionType:sessionTypeDict];
    [self populateSessionDetails:dataDict];
    
}
#pragma mark - End
@end
