//
//  PersonalSessionsViewController.m
//  Squad
//
//  Created by AQB SOLUTIONS on 09/02/2017.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import "PersonalSessionsViewController.h"
#import "MasterMenuViewController.h"
#import "PersonalSessionsTableViewCell.h"
#import "AddPersonalSessionViewController.h"
#import "MovePersonalSessionViewController.h"
#import "RateFitnessLevelViewController.h"
#import "ViewPersonalSessionViewController.h"
#import "CustomExerciseSettingsViewController.h"

@interface PersonalSessionsViewController () {
    IBOutlet NSLayoutConstraint *footerConstant;
    IBOutlet UIButton *menuButton;
    //ah new
    IBOutlet UITableView *table;
    IBOutlet UILabel *header;
    IBOutlet UILabel *pageNumber;
    
    IBOutlet UIButton *cancelMoveButton;
    
    IBOutlet UIButton *nextButton;
    
    IBOutlet UIButton *backToExSettingsButton;
    IBOutlet NSLayoutConstraint *backExButtonHeightConstraint;
    IBOutlet UIView *blankView;
    
    UIView *contentView;
    NSMutableArray *responseObjArray;
    NSArray *weekdays;
    int selectedIndex;
}

@end

@implementation PersonalSessionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //FeedBack_SB
    if(!([defaults integerForKey:@"CustomExerciseStepNumber"] == 0)){
        blankView.hidden = false;
        [self nextButtonPressed:nil];
    }else{
        blankView.hidden = true;
    }
    //FeedBack_SB
    
    //if([[self.navigationController.viewControllers firstObject] isKindOfClass:[TrailHomeViewController class]]){
    if(![Utility isSubscribedUser]){
        menuButton.hidden = true;
        footerConstant.constant = 0;
    }else{
        menuButton.hidden = false;
        footerConstant.constant = 75;
    }
    responseObjArray = [[NSMutableArray alloc]init];
    selectedIndex = -1;
    
    cancelMoveButton.hidden = true;
    cancelMoveButton.layer.borderWidth = 1;
    cancelMoveButton.layer.borderColor = [UIColor colorWithRed:228/255.0f green:39/255.0f blue:160/255.0f alpha:1.0].CGColor;
    
    table.estimatedRowHeight=40;
    table.sectionFooterHeight = CGFLOAT_MIN;
    table.rowHeight = UITableViewAutomaticDimension;
    table.sectionHeaderHeight = CGFLOAT_MIN;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    pageNumber.text = @"6 of 7";
    table.allowsMultipleSelection = NO;
    header.text = @"Are you currently doing any sports/gym classes you would like to include in your weekly schedule? \nIf yes, enter the class/sport below. If not click the arrow to continue. \n(This will impact the number of sessions you’re given).";
    
   /* fitnessLevelArray = @[
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
                              @"fitnessLevel" : @"I am advanced in strenght and fitness.I love to push my limit.",
                              @"isdropdown" : @false,
                              }
                          ];*/
   
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    NSDateFormatter * df = [[NSDateFormatter alloc] init];
    [df setLocale: [NSLocale currentLocale]];
    weekdays = [df weekdaySymbols];
    //    NSLog(@"wds %@",weekdays);
    [responseObjArray removeAllObjects];
    [self getUserPersonalSessions];
    
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
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - API Call
-(void)getUserPersonalSessions {
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
            self->contentView = [Utility activityIndicatorView:self];
        });
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSMutableURLRequest *request = [Utility getRequest:@"" api:@"GetUserPersonalSessions" append:[[defaults objectForKey:@"ABBBCOnlineUserId"] stringValue] forAction:@"GET"];
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
                                                                         [self->responseObjArray removeAllObjects];
                                                                         [self->responseObjArray addObjectsFromArray:[responseDict objectForKey:@"obj"]];
                                                                         
                                                                         [self->table reloadData];
                                                                     } else{
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

-(void) deleteSessionWithID:(int) weekDay {
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
        [mainDict setObject:[NSNumber numberWithInt:weekDay] forKey:@"WeekDay"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"DeleteSquadPersonalSessionOfUser" append:@""forAction:@"POST"];
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
                                                                          [self->responseObjArray removeAllObjects];
                                                                          [self getUserPersonalSessions];
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

-(void) updatedUserProgramSetupStepNo:(int) stepNumber{
    if ([defaults integerForKey:@"CustomExerciseStepNumber"] > 0) {// < stepNumber) {
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
-(void) swapApiCallWithDict:(NSMutableDictionary *)swapDict {
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
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"SquadSwapPersonalExerciseSession" append:@""forAction:@"POST"];
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
                                                                          self->cancelMoveButton.hidden = true;
                                                                          [self getUserPersonalSessions];
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
    RateFitnessLevelViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"RateFitnessLevel"];
    controller.isRateFitness = false;
    controller.isWeeklySession = true;
    [self.navigationController pushViewController:controller animated:NO];
}
-(IBAction)nextButtonPressed:(id)sender{
    [self updatedUserProgramSetupStepNo:7];
    MovePersonalSessionViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MovePersonalSession"];
//    controller.responseObjArray = responseObjArray;
    [self.navigationController pushViewController:controller animated:NO];
}

-(IBAction)personalSessionNameButtonTapped:(UIButton*)sender {
    AddPersonalSessionViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AddPersonalSession"];
    controller.dayIndex = (int)[sender tag];
    [self.navigationController pushViewController:controller animated:YES];
//    [self.navigationController presentViewController:controller animated:YES completion:nil];
}
-(IBAction)deleteButtonTapped:(UIButton *)sender {
    int weekDay = [sender.accessibilityHint intValue];
    
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Comfirm Delete"
                                          message:@"Do you want to delete this entry?"
                                          preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:@"Delete"
                               style:UIAlertActionStyleDestructive
                               handler:^(UIAlertAction *action)
                               {
                                   [self deleteSessionWithID:weekDay];
                               }];
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:@"No"
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {
                                       
                                   }];
    [alertController addAction:okAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
-(IBAction)cancelMoveButtonTapped:(id)sender {
    selectedIndex = -1;
    [table reloadData];
    cancelMoveButton.hidden = YES;
}
-(IBAction)moveSwapButtonTapped:(UIButton*)sender {
    NSLog(@"tag %ld",(long)[sender tag]);
    
    NSMutableDictionary *swapDict = [[NSMutableDictionary alloc] init];
    
    [swapDict setObject:[NSNumber numberWithInt:selectedIndex] forKey:@"DayFrom"];
    [swapDict setObject:[NSNumber numberWithInteger:[sender tag]-1] forKey:@"DayTo"];
    [self swapApiCallWithDict:swapDict];
}

-(IBAction)selectButtonTapped:(UIButton*)sender {
    NSLog(@"tag %ld",(long)[sender tag]);
    selectedIndex = (int)[sender tag]-1;
    [table reloadData];
    cancelMoveButton.hidden = false;
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
#pragma mark - TableView Datasource & Delegate


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *CellIdentifier = @"PersonalSessionsTableViewCell";
    PersonalSessionsTableViewCell *cell = (PersonalSessionsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // Configure the cell...
    if (cell == nil) {
        cell = [[PersonalSessionsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (indexPath.row == 6) {
        cell.dayNameLabel.text = [weekdays objectAtIndex:0];
    } else {
        cell.dayNameLabel.text = [weekdays objectAtIndex:indexPath.row+1];
    }
    
    cell.selectButton.hidden = true;
    cell.moveSwapButton.hidden = true;
    [cell.personalSessionNameButton setImage:[UIImage imageNamed:@"add_button.png"] forState:UIControlStateNormal];
    
    if (![Utility isEmptyCheck:responseObjArray]) {
        NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"SessionDay == %d", indexPath.row];
        NSArray *filterArray = [responseObjArray filteredArrayUsingPredicate:predicate1];
        if (filterArray.count > 0) {
            [cell.personalSessionNameButton setImage:nil forState:UIControlStateNormal];
            cell.personalSessionNameButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;    //ah 10.5
            cell.personalSessionNameButton.titleLabel.numberOfLines = 0;

            [cell.personalSessionNameButton setTitle:[NSString stringWithFormat:@"%@\n%d min",[[filterArray objectAtIndex:0] objectForKey:@"SessionTitle"], [[[filterArray objectAtIndex:0] objectForKey:@"Duration"] intValue]] forState:UIControlStateNormal] ;   //ah 10.5
            [cell.personalSessionNameButton setTitleColor:[UIColor colorWithRed:228/255.0f green:39/255.0f blue:160/255.0f alpha:1.0] forState:UIControlStateNormal] ;
            cell.deleteButton.hidden = false;
            [cell.deleteButton setAccessibilityHint:[NSString stringWithFormat:@"%@",[[filterArray objectAtIndex:0] objectForKey:@"SessionDay"]]];
            
            cell.selectButton.hidden = false;
            
            if (selectedIndex > -1 && selectedIndex != indexPath.row) {
                cell.moveSwapButton.hidden = false;
                [cell.moveSwapButton setTitle:@"Swap Here" forState:UIControlStateNormal];
            }
        } else {
            [cell.personalSessionNameButton setTitle:@"" forState:UIControlStateNormal] ;
            cell.deleteButton.hidden = true;
            if (selectedIndex > -1 && selectedIndex != indexPath.row) {
                cell.moveSwapButton.hidden = false;
                [cell.moveSwapButton setTitle:@"Move Here" forState:UIControlStateNormal];
            }
        }
    } else {
        [cell.personalSessionNameButton setTitle:@"" forState:UIControlStateNormal] ;
        [cell.personalSessionNameButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal] ;
        cell.deleteButton.hidden = true;
        if (selectedIndex > -1 && selectedIndex != indexPath.row) {
            cell.moveSwapButton.hidden = false;
            [cell.moveSwapButton setTitle:@"Move Here" forState:UIControlStateNormal];
        }
    }
    
    [cell.personalSessionNameButton addTarget:self
                                    action:@selector(personalSessionNameButtonTapped:)
                          forControlEvents:UIControlEventTouchUpInside];
    [cell.personalSessionNameButton setTag:indexPath.row];
    
    [cell.deleteButton addTarget:self
                                       action:@selector(deleteButtonTapped:)
                             forControlEvents:UIControlEventTouchUpInside];
    
    [cell.selectButton addTarget:self
                                       action:@selector(selectButtonTapped:)
                             forControlEvents:UIControlEventTouchUpInside];
    [cell.selectButton setTag:indexPath.row+1];
    
    [cell.moveSwapButton addTarget:self
                                       action:@selector(moveSwapButtonTapped:)
                             forControlEvents:UIControlEventTouchUpInside];
    [cell.moveSwapButton setTag:indexPath.row+1];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
