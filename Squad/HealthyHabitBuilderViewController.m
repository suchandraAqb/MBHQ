//
//  HealthyHabitBuilderViewController.m
//  Squad
//
//  Created by AQB SOLUTIONS on 05/09/2017.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import "HealthyHabitBuilderViewController.h"
#import "HealthyHabitBuilderTableViewCell.h"
#import "AccountabilityBuddiesListViewController.h"

//chayan 25/10/2017
#import "MyHealthyHabitListViewController.h"
#import "VisionGoalActionViewController.h"
#import "HowToUseHealthyHabitBuilderViewController.h"


@interface HealthyHabitBuilderViewController () {
    IBOutlet UIView *headerView;
    IBOutlet UILabel *headerLabel;
    IBOutletCollection(UIButton) NSArray *weekDateButtons;
    IBOutlet UITableView *table;
    IBOutlet UIButton *buddyButton;
    IBOutlet UIButton *messageButton;
    IBOutlet UITextView *messageTextView;
    IBOutlet UIView *messageContainerView;
    IBOutlet UIButton *messageSend;
    IBOutlet UIButton *saveButton;
    IBOutlet UIButton *headerDateButton;
    IBOutlet UIView *nodata;
    UIView *contentView;
    NSDate *thisWeek;
    NSDate *weekstart;
    NSMutableArray *weeklyCheckListArray;
    NSDictionary *typeIdDict;
    NSMutableArray *saveArray;
    NSDate *currentweekstart;
    int apiCount;
    BOOL isUserFound;
}

@end

@implementation HealthyHabitBuilderViewController
@synthesize friendId,friendName,friendEmail;
//ah accb(storyboard old change from 2 to 3)

- (void)viewDidLoad {
    [super viewDidLoad];
    apiCount = 0;
    if (friendId) {
        headerLabel.text = [NSString stringWithFormat:@"%@",friendName];
        headerView.backgroundColor = [UIColor colorWithRed:126.0f/255.0f green:201.0f/255.0f blue:224.0f/255.0f alpha:1];
    }else{
        headerLabel.text = @"My Habits List";
        headerView.backgroundColor = [UIColor colorWithRed:244.0f/255.0f green:39.0f/255.0f blue:171.0f/255.0f alpha:1];
    }
    typeIdDict = @{
                   @"1":	@"Daily",
                   @"2":	@"Twice Daily",
                   @"3":	@"Weekly",
                   @"4":	@"Fortnightly",
                   @"5":	@"Monthly"
                   };
    
    if (friendId) {
        buddyButton.hidden = true;
        messageButton.hidden = false;
        saveButton.hidden = true;
    }else{
        buddyButton.hidden = false;
        messageButton.hidden = true;
        saveButton.hidden = false;
    }
    messageTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    messageTextView.layer.borderWidth = 1.0f;
    table.estimatedRowHeight = 150;
    table.rowHeight = UITableViewAutomaticDimension;
    for (UIButton *btn in weekDateButtons) {
        btn.layer.borderWidth = 1;
        btn.layer.borderColor = [[UIColor whiteColor] CGColor];
        btn.clipsToBounds = true;
    }

    thisWeek = currentweekstart = weekstart = [self getWeekStartDateFrom:[NSDate date]];
    
    
    if(![defaults boolForKey:@"isCheckHowToUse"]){
        [defaults setBool:YES forKey:@"isCheckHowToUse"];
        [self gotoHowToUse];
    }
    
    if([Utility isUserLoggedInToChatSdk]){
        [Utility updateUserDetailsToFirebase];
    }
    
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    NSMutableArray *monthsArray = [[NSMutableArray alloc] init];
    NSMutableArray *yearsArray = [[NSMutableArray alloc] init];
    saveArray = [[NSMutableArray alloc] init];
    [Utility stopFlashingbutton:saveButton];
    saveButton.hidden = true;
    weeklyCheckListArray = [[NSMutableArray alloc] init];
    messageContainerView.hidden = true;
    nodata.hidden = true;
    [self weeklyCheckViewApiCallFromDate:currentweekstart];
    
    int i = 0;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd/MM"];
    
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents* components = [gregorian components:NSCalendarUnitMonth|NSCalendarUnitYear fromDate:weekstart];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [monthsArray addObject:[[df monthSymbols] objectAtIndex:([components month]-1)]];
    
    NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
    
    for (UIButton *dateButton in weekDateButtons) {
        [componentsToSubtract setDay:-7*i];
        NSDate *newDate = [gregorian dateByAddingComponents:componentsToSubtract toDate:weekstart options:0];
        NSString *newDateStr = [formatter stringFromDate:newDate];
        NSDateFormatter *formatter123 = [[NSDateFormatter alloc] init];
        [formatter123 setDateFormat:@"dd/MM/yyyy"];
        if ([[formatter123 stringFromDate:thisWeek] isEqualToString:[formatter123 stringFromDate:newDate]]) {
            [dateButton setTitle:@"This Week" forState:UIControlStateNormal];
        }else{
            [dateButton setTitle:newDateStr forState:UIControlStateNormal];
        }
        
        NSDateComponents* components = [gregorian components:NSCalendarUnitMonth|NSCalendarUnitYear fromDate:newDate];
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [monthsArray addObject:[[df monthSymbols] objectAtIndex:([components month]-1)]];
        [yearsArray addObject:[NSString stringWithFormat:@"%ld",(long)[components year]]];
        i++;
    }
    NSArray * uniqueArray = [[NSOrderedSet orderedSetWithArray:monthsArray] array];
    uniqueArray = [[uniqueArray reverseObjectEnumerator] allObjects];
    NSArray * uniqueArrayYear = [[NSOrderedSet orderedSetWithArray:yearsArray] array];
    if (uniqueArrayYear.count == 1) {
        [headerDateButton setTitle:[NSString stringWithFormat:@"%@ %@",[uniqueArray componentsJoinedByString:@"/"],[uniqueArrayYear objectAtIndex:0]] forState:UIControlStateNormal];
    } else {
        uniqueArrayYear = [[uniqueArrayYear reverseObjectEnumerator] allObjects];
        [headerDateButton setTitle:[NSString stringWithFormat:@"%@ %@/%@ %@",[uniqueArray objectAtIndex:0], [uniqueArrayYear objectAtIndex:0],[uniqueArray objectAtIndex:1],[uniqueArrayYear objectAtIndex:1]] forState:UIControlStateNormal];
    }

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction
- (IBAction)dateButtonPressed:(UIButton *)sender {
    [self shouldPopOnBackButtonWithResponse:^(BOOL shouldPop) {
        if (shouldPop) {
            DatePickerViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DatePicker"];
            controller.modalPresentationStyle = UIModalPresentationCustom;
            controller.maxDate = [NSDate date];
            //    NSTimeInterval sixmonth = -6*30*24*60*60;
            //    controller.minDate = [[NSDate date]
            //                          dateByAddingTimeInterval:sixmonth];
            controller.selectedDate = self->weekstart;
            controller.datePickerMode = UIDatePickerModeDate;
            controller.delegate = self;
            [self presentViewController:controller animated:YES completion:nil];
        }
    }];
}

- (IBAction)menuTapped:(id)sender {
    [self shouldPopOnBackButtonWithResponse:^(BOOL shouldPop) {
        if (shouldPop) {
            [self.slidingViewController anchorTopViewToRightAnimated:YES];
            [self.slidingViewController resetTopViewAnimated:YES];
        }
    }];
    
}
- (IBAction)logoTapped:(id)sender {
    [self shouldPopOnBackButtonWithResponse:^(BOOL shouldPop) {
        if (shouldPop) {
            [self.navigationController  popToRootViewControllerAnimated:YES];
        }
    }];
}

- (IBAction)backTapped:(id)sender {
    [self shouldPopOnBackButtonWithResponse:^(BOOL shouldPop) {
        if (shouldPop) {
            [self.navigationController  popViewControllerAnimated:YES];
        }
    }];
}

- (IBAction)weekDateButtonTapped:(UIButton *)sender{
    [self shouldPopOnBackButtonWithResponse:^(BOOL shouldPop) {
        if (shouldPop) {
            for (UIButton *btn in weekDateButtons) {
                if (sender == btn) {
                    [btn setBackgroundColor:[UIColor whiteColor]];
                    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                } else {
                    [btn setBackgroundColor:[UIColor clearColor]];
                    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                }
            }
            NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
            NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
            [componentsToSubtract setDay:-7*sender.tag];
            NSDate *newDate = [gregorian dateByAddingComponents:componentsToSubtract toDate:weekstart options:0];
            currentweekstart = newDate;
            weeklyCheckListArray = [[NSMutableArray alloc] init];
            [self weeklyCheckViewApiCallFromDate:newDate];
        }
    }];
    
}
- (IBAction)saveButtonTapped:(id)sender {
    [self saveData];
}
- (IBAction)manageFriendsButtonTapped:(id)sender {
    [self shouldPopOnBackButtonWithResponse:^(BOOL shouldPop) {
        if (shouldPop) {
            AccountabilityBuddiesListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AccountabilityBuddiesList"];
            [self.navigationController pushViewController:controller animated:YES ];
        }
    }];
}
- (IBAction)moreButtonTapped:(id)sender {
    if(friendId){
        MyHealthyHabitListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MyHealthyHabitList"];
        [self.navigationController pushViewController:controller animated:YES ];
    }else{
        [self shouldPopOnBackButtonWithResponse:^(BOOL shouldPop) {
            if (shouldPop) {
                //chayan 25/10/2017
                UIAlertController* alert = [UIAlertController
                                            alertControllerWithTitle:nil      //  Must be "nil", otherwise a blank title area will appear above our two buttons
                                            message:nil
                                            preferredStyle:UIAlertControllerStyleActionSheet];
                
                UIAlertAction* button0 = [UIAlertAction
                                          actionWithTitle:@"Cancel"
                                          style:UIAlertActionStyleCancel
                                          handler:^(UIAlertAction * action)
                                          {
                                              //  UIAlertController will automatically dismiss the view
                                          }];
                
                UIAlertAction* button1 = [UIAlertAction
                                          actionWithTitle:@"Add an Action"
                                          style:UIAlertActionStyleDefault
                                          handler:^(UIAlertAction * action)
                                          {
                                              MyHealthyHabitListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MyHealthyHabitList"];
                                              [self.navigationController pushViewController:controller animated:YES ];
                                              
                                          }];
                
                UIAlertAction* button2 = [UIAlertAction
                                          actionWithTitle:@"Vision/Goals/Actions"
                                          style:UIAlertActionStyleDefault
                                          handler:^(UIAlertAction * action)
                                          {
                                              VisionGoalActionViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"VisionGoalAction"];
                                              [self.navigationController pushViewController:controller animated:YES ];
                                          }];
                
                UIAlertAction* button3 = [UIAlertAction
                                          actionWithTitle:@"How to Use"
                                          style:UIAlertActionStyleDefault
                                          handler:^(UIAlertAction * action)
                                          {
                                              [self gotoHowToUse];
                                          }];
                
                
                
                [alert addAction:button0];
                [alert addAction:button1];
                [alert addAction:button2];
                [alert addAction:button3];
                [self presentViewController:alert animated:YES completion:nil];

            }
        }];
    }
    
}
//- (IBAction)msgButtonTapped:(id)sender {
//    //messageContainerView.hidden = !messageContainerView.hidden;
//    if(![Utility isEmptyCheck:friendEmail]){
//        
//        NSString *email = friendEmail;
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            
//            if (self->contentView) {
//                [self->contentView removeFromSuperview];
//            }
//            
//            self->contentView = [Utility activityIndicatorView:self];
//            
//        });
//        
//        isUserFound = false;
//        
//        [NM.search usersForIndexes:@[bUserEmailKey] withValue:email limit: 1 userAdded: ^(id<PUser> user) {
//            
//            // Make sure we run this on the main thread
//            dispatch_async(dispatch_get_main_queue(), ^{
//                
//                if (user != Nil && user != NM.currentUser) {
//                    // Only display a user if they have a name set
//                    self->isUserFound = true;
//                    
//                    NSString *name = user.name;
//                    
//                    if([Utility isEmptyCheck:name] && ![Utility isEmptyCheck:self->friendName]){
//                        [user setName:[NSString stringWithFormat:@"%@",self->friendName]];
//                    }
//                    
//                    
//                    [NM.core createThreadWithUsers:@[user] threadCreated:^(NSError * error, id<PThread> thread) {
//                        
//                        dispatch_async(dispatch_get_main_queue(),^ {
//                            
//                            if (self->contentView) {
//                                [self->contentView removeFromSuperview];
//                            }
//                        });
//                        
//                        UIViewController * chatViewController = [[BInterfaceManager sharedManager].a chatViewControllerWithThread:thread];
//                        [self.navigationController pushViewController:chatViewController animated:YES];
//                    }];
//                }else{
//                    
//                    dispatch_async(dispatch_get_main_queue(),^ {
//                        
//                        if (self->contentView) {
//                            [self->contentView removeFromSuperview];
//                        }
//                        if(!self->isUserFound)[Utility msg:ChatCreationError title:@"" controller:self haveToPop:NO];
//                    });
//                }
//                
//                
//            });
//            
//        }].thenOnMain(^id(id success) {
//            
//            dispatch_async(dispatch_get_main_queue(),^ {
//                
//                if (self->contentView) {
//                    [self->contentView removeFromSuperview];
//                }
//                if(!self->isUserFound)[Utility msg:ChatCreationError title:@"" controller:self haveToPop:NO];
//            });
//            
//            return Nil;
//        }, ^id(NSError * error) {
//            
//            dispatch_async(dispatch_get_main_queue(),^ {
//                
//                if (self->contentView) {
//                    [self->contentView removeFromSuperview];
//                }
//                if(!self->isUserFound)[Utility msg:ChatCreationError title:@"" controller:self haveToPop:NO];
//            });
//            
//            return error;
//        });
//        
//        
//        
//    }
//}
- (IBAction)msgSendButtonTapped:(id)sender {    //ah 02
    if (messageTextView.text.length > 0) {
        NSDate *currentDate = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMM dd yyyy hh:mm:ss.SSSa"];
        NSString *currentDateStr = [formatter stringFromDate:currentDate];
        NSMutableDictionary *sendMessageDict = [[NSMutableDictionary alloc]init];
        [sendMessageDict setObject:[defaults objectForKey:@"UserID"] forKey:@"senderId"];
        [sendMessageDict setObject:friendId forKey:@"receiverId"];
        [sendMessageDict setObject:messageTextView.text forKey:@"content"];
        [sendMessageDict setObject:currentDateStr forKey:@"sendTime"];
        [sendMessageDict setObject:AccessKey forKey:@"Key"];
        [sendMessageDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionId"];
        [self sendMessageWebserviceCall:sendMessageDict];
    } else {
        [Utility msg:@"Please type a message to send" title:@"Oops!" controller:self haveToPop:NO];
    }
    
    
}
- (IBAction)checkButtonTapped:(UIButton *)sender {
    NSLog(@"check %ld",(long)sender.tag);
    NSArray* detailsArr = [sender.accessibilityHint componentsSeparatedByString:@"-"];
    for (int l = 0; l<weeklyCheckListArray.count; l++) {
        NSDictionary *dataDict = weeklyCheckListArray[l];
        if (![Utility isEmptyCheck:dataDict] && [dataDict[@"HabitId"] intValue] == [detailsArr[0] integerValue]) {
            NSMutableDictionary *tempDataDict = [dataDict mutableCopy];
            if (![Utility isEmptyCheck:dataDict[@"WeeklyCheck"]]) {
                NSMutableArray *weeklyCheck = [dataDict[@"WeeklyCheck"]mutableCopy];
                if (weeklyCheck.count>[detailsArr[2] intValue]) {
                    NSMutableDictionary *temp = [weeklyCheck[[detailsArr[2] intValue]] mutableCopy];
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    [formatter setDateFormat:@"yyyy-MM-dd"];
                    NSString *startDateStr = [formatter stringFromDate:currentweekstart];

                    //NSString *startDateStr = [NSString stringWithFormat:@"%@T00:00:00+00:00",[formatter stringFromDate:currentweekstart]];
                    //NSString *endDateStr = [NSString stringWithFormat:@"%@T23:59:59+00:00",[formatter stringFromDate:currentweekstart]];
                    //[formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZZ"];
                    NSDate *startDate = [formatter dateFromString:startDateStr];
                    //NSDate *endDate = [formatter dateFromString:endDateStr];
                    
                    if (![Utility isEmptyCheck:temp[@"WeekStartDate"]]){
                        NSString *tmpDtStr = [NSString stringWithFormat:@"%@",[temp objectForKey:@"WeekStartDate"]];
                        if (tmpDtStr.length >= 10) {
                            tmpDtStr = [tmpDtStr substringToIndex:10];
                            NSDate *weekStartDate = [formatter dateFromString:tmpDtStr];
                            if ([weekStartDate compare:[NSDate date]] == NSOrderedAscending) {
                                if (sender.isSelected) {
                                    [sender setSelected:NO];
                                } else {
                                    [sender setSelected:YES];
                                }
                                if ([detailsArr[1] intValue] == 0) {
                                    [temp setObject:[NSNumber numberWithBool:sender.selected] forKey:@"CheckStatus"];
                                }else{
                                    [temp setObject:[NSNumber numberWithBool:sender.selected] forKey:@"CheckStatus2nd"];
                                }
                                [weeklyCheck replaceObjectAtIndex:[detailsArr[2] intValue] withObject:temp];
                                [tempDataDict setObject:weeklyCheck forKey:@"WeeklyCheck"];
                                
                                
                                NSMutableArray *weeklyCheckView = [dataDict[@"WeeklyCheckView"]mutableCopy];
                                for (int k = 0; k < weeklyCheckView.count; k++) {
                                    NSMutableDictionary *dict1 = [[weeklyCheckView objectAtIndex:k] mutableCopy];
                                    NSString *dtStr = [NSString stringWithFormat:@"%@",[dict1 objectForKey:@"WeekStartDate"]];
                                    if (dtStr.length >= 10) {
                                        dtStr = [dtStr substringToIndex:10];
                                    }
                                    NSDate *dt = [formatter dateFromString:dtStr];
                                    //if ((([dt compare:startDate] == NSOrderedDescending)||([dt compare:startDate] == NSOrderedSame)) && (([dt compare:endDate] == NSOrderedAscending)||([dt compare:endDate] == NSOrderedSame))) {
                                    if ([dt compare:startDate] == NSOrderedSame) {
                                        if (sender.selected) {
                                            [dict1 setObject:[NSNumber numberWithInt:[dict1[@"Count"] intValue]+1] forKey:@"Count"];
                                        }else{
                                            [dict1 setObject:[NSNumber numberWithInt:[dict1[@"Count"] intValue]-1] forKey:@"Count"];
                                        }
                                        [weeklyCheckView replaceObjectAtIndex:k withObject:dict1];
                                        [tempDataDict setObject:weeklyCheckView forKey:@"WeeklyCheckView"];
                                        break;
                                    }
                                }
                                
                                [weeklyCheckListArray replaceObjectAtIndex:l withObject:tempDataDict];
                                [table reloadData];
                                
                                //                    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
                                //                    NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
                                //                    [componentsToSubtract setDay:[detailsArr[2] integerValue]];
                                //                    NSDate *newDate = [gregorian dateByAddingComponents:componentsToSubtract toDate:currentweekstart options:0];
                                //                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                                //                    //[formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSSZZZZZ"];
                                //                    [formatter setDateFormat:@"yyyy-MM-dd"];
                                //
                                //                    NSString *newDateStr = [formatter stringFromDate:newDate];
                                
                                NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                                [dict setObject:[defaults objectForKey:@"UserID"] forKey:@"UserId"];
                                [dict setObject:temp[@"WeekStartDate"] forKey:@"CheckDate"];
                                [dict setObject:detailsArr[0] forKey:@"HabitId"];
                                [dict setObject:detailsArr[1] forKey:@"Type"];
                                

                                if([saveArray containsObject:dict]){
                                    [saveArray removeObject:dict];
                                }else{
                                    [saveArray addObject:dict];
                                }
                                
                                if(saveArray.count > 0){
                                    [Utility startFlashingbutton:saveButton];
                                }else{
                                    [Utility stopFlashingbutton:saveButton];
                                    saveButton.hidden = true;
                                }
                                break;
                            }else{
                                [Utility msg:@"You can't check this day." title:@"Warning !" controller:self haveToPop:NO];
                                return;
                            }
                        }
                    }
                }
            }
            
        }
    }
    
    
}

#pragma mark - API Call
-(void) sendMessageWebserviceCall:(NSDictionary *)sendMessageDict{
    [messageTextView resignFirstResponder];
    if (Utility.reachable) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            apiCount++;
            if (contentView) {
                [contentView removeFromSuperview];
            }
            contentView = [Utility activityIndicatorView:self];
        });
        
        NSURLSession *loginSession = [NSURLSession sharedSession];
        
        NSLog(@"send msg dict %@",sendMessageDict);
        
        NSError *error;
        NSData *postData = [NSJSONSerialization dataWithJSONObject:sendMessageDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"SendMessageToFriend" append:@"" forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[loginSession
                                          dataTaskWithRequest:request
                                          completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                              dispatch_async(dispatch_get_main_queue(),^ {
                                                  apiCount--;
                                                  if (contentView && apiCount == 0) {
                                                      [contentView removeFromSuperview];
                                                  }
                                                  if(error == nil)
                                                  {
                                                      NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                      NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                      if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDictionary] && [[responseDictionary objectForKey:@"Success"] boolValue]) {
                                                          messageContainerView.hidden = true;
                                                          messageTextView.text = @"";
                                                       }else{
                                                          [Utility msg:[responseDictionary objectForKey:@"ErrorMessage"] title:@"Error !" controller:self haveToPop:NO];
                                                           return;
                                                      }
                                                      
                                                  }else{
                                                      [Utility msg:error.localizedDescription title:@"Error !" controller:self haveToPop:NO];
                                                  }
                                              });
                                          }];
        [dataTask resume];
        
    } else {
        [Utility msg:@"Check Your network connection and try again." title:@"Error !" controller:self haveToPop:NO];
    }
}

-(void) weeklyCheckViewApiCallFromDate:(NSDate *)newDate {
    if (Utility.reachable) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            apiCount++;
            if (contentView) {
                [contentView removeFromSuperview];
            }
            contentView = [Utility activityIndicatorView:self];
            weeklyCheckListArray = [[NSMutableArray alloc] init];
        });
        
        NSURLSession *customSession = [NSURLSession sharedSession];
        
        NSError *error;
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];     //2017-03-06T10:38:18.7877+00:00
        NSString *currentDateStr = [formatter stringFromDate:newDate];

        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        if(friendId){
            [mainDict setObject:friendId forKey:@"UserID"];
        }else{
            [mainDict setObject:[defaults objectForKey:@"UserID"] forKey:@"UserID"];
        }
        [mainDict setObject:currentDateStr forKey:@"WeekDate"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetWeeklyCheckView" append:@""forAction:@"POST"];
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
                                                                          NSArray *tempArray = [responseDict objectForKey:@"WeekllCheckList"];
                                                                          if (tempArray.count==0) {
                                                                              nodata.hidden = false;
                                                                              /*if (friendId) {
                                                                                  nodata.hidden = false;
                                                                              }else{
                                                                                  NSDateFormatter *formatter123 = [[NSDateFormatter alloc] init];
                                                                                  [formatter123 setDateFormat:@"dd/MM/yyyy"];
                                                                                  if ([[formatter123 stringFromDate:thisWeek] isEqualToString:[formatter123 stringFromDate:newDate]]) {
                                                                                      MyHealthyHabitListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MyHealthyHabitList"];
                                                                                      [self.navigationController pushViewController:controller animated:YES ];
                                                                                  }else{
                                                                                      nodata.hidden = false;
                                                                                  }
                                                                                  
                                                                              }*/
                                                                          }else{
                                                                              nodata.hidden = true;
                                                                              if(friendId){
                                                                                  weeklyCheckListArray = [[tempArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(Visible == %d)", 1]] mutableCopy];
                                                                                  NSLog(@"%@",weeklyCheckListArray);
                                                                                  
                                                                              }else{
                                                                                  weeklyCheckListArray = [tempArray mutableCopy];
                                                                              }
                                                                          }
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

- (void) saveData {
    if (saveArray.count > 0) {
        if (Utility.reachable) {
            dispatch_async(dispatch_get_main_queue(), ^{
                apiCount++;
                if (contentView) {
                    [contentView removeFromSuperview];
                }
                contentView = [Utility activityIndicatorView:self];
                weeklyCheckListArray = [[NSMutableArray alloc] init];
            });
            
            NSURLSession *customSession = [NSURLSession sharedSession];
            
            NSError *error;
            
            NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
            [mainDict setObject:AccessKey forKey:@"Key"];
            [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
            [mainDict setObject:saveArray forKey:@"ToggleCheckData"];
            
            NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
            if (error) {
                [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
                return;
            }
            NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
            
            NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"ToggleDailyCheck" append:@""forAction:@"POST"];
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
                                                                          if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"]boolValue]) {
                                                                              saveArray = [[NSMutableArray alloc] init];
                                                                              [self viewWillAppear:YES];
                                                                              [Utility msg:@"" title:@"Saved Successfully" controller:self haveToPop:NO];
                                                                              
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
#pragma mark - Private Methods

- (void) shouldPopOnBackButtonWithResponse:(void (^)(BOOL shouldPop))response {
    if (saveArray.count >0) {
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"Save Changes"
                                              message:@"Your changes will be lost if you don’t save them."
                                              preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:@"Save"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       [self saveData];
                                       response(NO);
                                   }];
        UIAlertAction *cancelAction = [UIAlertAction
                                       actionWithTitle:@"Don't Save"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction *action)
                                       {
                                           saveArray = [[NSMutableArray alloc]init];
                                           [Utility stopFlashingbutton:saveButton];
                                           saveButton.hidden = true;
                                           response(YES);
                                       }];
        [alertController addAction:okAction];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    } else {
        response(YES);
    }
}
- (NSDate *) getWeekStartDateFrom:(NSDate *) todayDate {
//    NSDate* sourceDate = todayDate;
//    
//    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
//    NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];
//    
//    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:sourceDate];
//    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:sourceDate];
//    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
//    
//    NSDate* destinationDate = [[NSDate alloc] initWithTimeInterval:interval sinceDate:sourceDate];
    
    
    
    NSDate *today = todayDate;
    //NSDate *today = destinationDate;
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    /*
     Create a date components to represent the number of days to subtract from the current date.
     The weekday value for Sunday in the Gregorian calendar is 1, so subtract 1 from the number of days to subtract from the date in question. (If today is Sunday, subtract 0 days.)
     */
    NSDateComponents *weekdayComponents = [gregorian components:NSCalendarUnitWeekday fromDate:today];
    NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
    if ([weekdayComponents weekday] == 1) {
        [componentsToSubtract setDay:-6];
    }else{
        [componentsToSubtract setDay:(0 - ([weekdayComponents weekday] - 2))];
    }
    NSDate *weekstartDate = [gregorian dateByAddingComponents:componentsToSubtract toDate:today options:0];
    return weekstartDate;
}
-(void)gotoHowToUse{
    HowToUseHealthyHabitBuilderViewController *controller=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HowToUseHealthyHabitBuilder"];
    controller.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:controller animated:YES completion:nil];
}
#pragma mark - TableView Datasource & Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return weeklyCheckListArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HealthyHabitBuilderTableViewCell *cell = (HealthyHabitBuilderTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"HealthyHabitBuilderTableViewCell"];
    // Configure the cell...
    if (cell == nil) {
        cell = [[HealthyHabitBuilderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HealthyHabitBuilderTableViewCell"];
    }
    
    NSDictionary *dict = [weeklyCheckListArray objectAtIndex:indexPath.row];
    if (![Utility isEmptyCheck:dict]) {
        cell.watchButton.selected = [dict[@"Visible"] boolValue];
        cell.actionTitleLabel.text = [dict objectForKey:@"HabitName"];
        cell.actionFrequencyLabel.text = [NSString stringWithFormat:@"(%@)",[dict objectForKey:@"HabitTypeName"]];
        cell.countView.layer.borderWidth = 1;
        cell.countView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        cell.countView.clipsToBounds = true;
        
        if ([[dict objectForKey:@"HabitTypeId"] intValue] == 2) {
            cell.secondCheckView.hidden = false;
        } else {
            cell.secondCheckView.hidden = true;
        }
        
        NSArray *totalCounts = [[NSArray alloc] init];
        if (![Utility isEmptyCheck:[dict objectForKey:@"TotalCount"]]) {
            NSString *totalCount = [dict objectForKey:@"TotalCount"];
            totalCounts = [totalCount componentsSeparatedByString:@","];
        }
        NSArray *weeklyCheck = [dict objectForKey:@"WeeklyCheck"];
        for (int i = 0; i < weeklyCheck.count; i++) {
            UIButton *firstCheckButton = cell.firstCheckButtons[i];
            UIButton *secondCheckButton = cell.secondCheckButtons[i];
            firstCheckButton.selected = [[[weeklyCheck objectAtIndex:i] objectForKey:@"CheckStatus"] boolValue];
            secondCheckButton.selected = [[[weeklyCheck objectAtIndex:i] objectForKey:@"CheckStatus2nd"] boolValue];
            if (friendId) {
                firstCheckButton.userInteractionEnabled = false;
                firstCheckButton.userInteractionEnabled = false;
            }else{
                firstCheckButton.userInteractionEnabled = true;
                firstCheckButton.userInteractionEnabled = true;
            }
            [firstCheckButton setAccessibilityHint:[NSString stringWithFormat:@"%d-%d-%d",[[dict objectForKey:@"HabitId"] intValue],0,i]];      //HabitId-Type-dayNumber
            [secondCheckButton setAccessibilityHint:[NSString stringWithFormat:@"%d-%d-%d",[[dict objectForKey:@"HabitId"] intValue],1,i]];
            if (![Utility isEmptyCheck:totalCounts]) {
                if ([totalCounts containsObject:[NSString stringWithFormat:@"%d",i+1]]) {
                    firstCheckButton.hidden = false;
                } else {
                    firstCheckButton.hidden = true;
                }
            } else {
                firstCheckButton.hidden = false;
            }
        }
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSString *startDateStr = [formatter stringFromDate:currentweekstart];

        //NSString *startDateStr = [NSString stringWithFormat:@"%@T00:00:00+00:00",[formatter stringFromDate:currentweekstart]];
        //NSString *endDateStr = [NSString stringWithFormat:@"%@T23:59:59+00:00",[formatter stringFromDate:currentweekstart]];
        //[formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZZ"];
        NSDate *startDate = [formatter dateFromString:startDateStr];
        //NSDate *endDate = [formatter dateFromString:endDateStr];
        
        NSArray *weeklyCheckView = [dict objectForKey:@"WeeklyCheckView"];
        for (int k = 0; k < weeklyCheckView.count; k++) {
            NSDictionary *dict1 = [weeklyCheckView objectAtIndex:k];
            NSString *dtStr = [NSString stringWithFormat:@"%@",[dict1 objectForKey:@"WeekStartDate"]];
            if (dtStr.length >= 10) {
                dtStr = [dtStr substringToIndex:10];
            }
            NSDate *dt = [formatter dateFromString:dtStr];
            //if ((([dt compare:startDate] == NSOrderedDescending)||([dt compare:startDate] == NSOrderedSame)) && (([dt compare:endDate] == NSOrderedAscending)||([dt compare:endDate] == NSOrderedSame))) {
            if ([dt compare:startDate] == NSOrderedSame) {
                cell.countLabel.text = [NSString stringWithFormat:@"%d of %d",[[dict1 objectForKey:@"Count"] intValue],[[dict1 objectForKey:@"Total"] intValue]];
                break;
            } else {
                cell.countLabel.text = @"0 of 14";
            }
        }
    }

    return cell;
}

#pragma  mark -DatePickerViewControllerDelegate
-(void)didSelectDate:(NSDate *)date{
    NSLog(@"%@\n%@",date,[defaults objectForKey:@"Timezone"]);
    if (date) {
        currentweekstart = weekstart = [self getWeekStartDateFrom:date];
        int i=0;
        for (UIButton *btn in weekDateButtons) {
            if (i == 0) {
                [btn setBackgroundColor:[UIColor whiteColor]];
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            } else {
                [btn setBackgroundColor:[UIColor clearColor]];
                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }
            i++;
        }
        [self viewWillAppear:YES];
//        static NSDateFormatter *dateFormatter;
//        dateFormatter = [NSDateFormatter new];
//        
//        //[dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:[defaults objectForKey:@"Timezone"]]];
//        [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
//        selectedDate = date;
//        [dateFormatter setDateFormat:@"dd-MMM-yyyy"];
//        NSString *dateString = [dateFormatter stringFromDate:date];
//        [dateAddedButton setTitle:dateString forState:UIControlStateNormal];
    }
}
@end
