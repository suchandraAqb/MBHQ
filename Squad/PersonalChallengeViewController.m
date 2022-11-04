//
//  PersonalChallengeViewController.m
//  Squad
//
//  Created by aqb-mac-mini3 on 12/07/18.
//  Copyright © 2018 AQB Solutions. All rights reserved.
//

#import "PersonalChallengeViewController.h"
#import "PersonalChallengeTableViewCell.h"
#import "PersonalChallengeAddEditViewController.h"
#import "PersonalChallengeDetailsViewController.h"
#import "PersonalChallengeHeaderView.h"

@interface PersonalChallengeViewController (){
    
    __weak IBOutlet UIButton *headerButton;
    __weak IBOutlet UIButton *addChallengeButton;
    __weak IBOutlet UIButton *challengeListButton;
    __weak IBOutlet UIButton *myChallengeButton;
    __weak IBOutlet UITableView *challengeTable;
    __weak IBOutlet UILabel *noDataLabel;
    
    __weak IBOutlet UITableView *userTable;
    NSArray *userList;
    __weak IBOutlet UIView *userListView;
    __weak IBOutlet UIView *shareView;
    
    UIView *contentView;
    int apiCount;
    NSMutableArray *challengeArray;
    BOOL isFirstTimeReminderSet;
    BOOL isLoadController;
    NSDictionary *activeDict;
    BOOL showCompleted;
    BOOL firstTimeApiLoad;
}

@end

@implementation PersonalChallengeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    firstTimeApiLoad = true;
    showCompleted = false;
    isLoadController = YES;
    apiCount = 0;
    isFirstTimeReminderSet = true;
    challengeArray = [NSMutableArray new];
    challengeTable.hidden = true;
    noDataLabel.hidden = true;
    userListView.hidden = true;
    shareView.hidden = true;
    UINib *sectionHeaderNib = [UINib nibWithNibName:@"PersonalChallengeHeaderView" bundle:nil];
    [challengeTable registerNib:sectionHeaderNib forHeaderFooterViewReuseIdentifier:@"PersonalChallengeHeaderView"];
    challengeTable.estimatedRowHeight = UITableViewAutomaticDimension;
    challengeTable.rowHeight = UITableViewAutomaticDimension;
    userTable.estimatedRowHeight = 50;
    userTable.rowHeight = UITableViewAutomaticDimension;
    userTable.sectionHeaderHeight = 0;
    challengeListButton.selected = false;
    myChallengeButton.selected = true;
    challengeListButton.layer.borderWidth = 1;
    challengeListButton.layer.borderColor = [UIColor colorWithRed:228/255.0f green:39/255.0f blue:160/255.0f alpha:1.0f].CGColor;
    [challengeListButton setBackgroundColor:[UIColor whiteColor]];
    myChallengeButton.layer.borderWidth = 1;
    myChallengeButton.layer.borderColor = [UIColor colorWithRed:228/255.0f green:39/255.0f blue:160/255.0f alpha:1.0f].CGColor;
    [myChallengeButton setBackgroundColor:[UIColor colorWithRed:228/255.0f green:39/255.0f blue:160/255.0f alpha:1.0f]];
    [headerButton setTitle:@"MY PERSONAL CHALLENGE" forState:UIControlStateNormal];
    addChallengeButton.layer.borderWidth = 1;
    addChallengeButton.layer.borderColor = [UIColor colorWithRed:228/255.0f green:39/255.0f blue:160/255.0f alpha:1.0f].CGColor;
    
}
-(void)viewWillAppear:(BOOL)animated{
    if(!isLoadController){
        return;
    }
    isLoadController = false;
    if (myChallengeButton.isSelected) {
        [self getPersonalChallenge:true myPersonal:true];
    } else {
        [self getPersonalChallenge:true myPersonal:false];
    }
}
#pragma mark -IBAction

- (IBAction)addButtonPressed:(UIButton *)sender {
    PersonalChallengeAddEditViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PersonalChallengeAddEdit"];
    controller.delegate = self;
    controller.isAdd = true;
    [self.navigationController pushViewController:controller animated:YES];
}
- (IBAction)challengeListButtonPressed:(UIButton *)sender {
    if (!sender.isSelected) {
        
        sender.selected = true;
        [sender setBackgroundColor:[UIColor colorWithRed:228/255.0f green:39/255.0f blue:160/255.0f alpha:1.0f]];
        [challengeArray removeAllObjects];
        if (sender == challengeListButton) {
            [headerButton setTitle:@"PERSONAL CHALLENGE" forState:UIControlStateNormal];
            myChallengeButton.selected = false;
            [myChallengeButton setBackgroundColor:[UIColor whiteColor]];
            [self getPersonalChallenge:true myPersonal:false];
        } else if (sender == myChallengeButton) {
            [headerButton setTitle:@"MY PERSONAL CHALLENGE" forState:UIControlStateNormal];
            challengeListButton.selected = false;
            [challengeListButton setBackgroundColor:[UIColor whiteColor]];
            [self getPersonalChallenge:true myPersonal:true];
        }
    }
//    else{
//        if (![Utility isEmptyCheck:challengeArray]) {
//            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//            [self->challengeTable scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
//        }
//    }
}
- (IBAction)publicButtonPressed:(UIButton *)sender {
    NSDictionary *temp = [challengeArray objectAtIndex:[sender.accessibilityHint intValue]];
    NSArray *chlngArray = temp[@"challenge"];
    temp = chlngArray[sender.tag];
    int member = ![Utility isEmptyCheck:temp[@"JoinMember"]]?[temp[@"JoinMember"] intValue]:1;
//    BOOL share = ![Utility isEmptyCheck:temp[@"Shareable"]]?[temp[@"Shareable"] boolValue]:false;
    if (member <= 1 && ([temp[@"UserId"] integerValue] == [[defaults objectForKey:@"UserID"] integerValue]) && ![temp[@"IsSquadCreated"] boolValue]) {
        [self toggleVisibleApiCall:temp[@"HabitId"]];
    }else{
        [Utility msg:@"You can not change a public challenge to private challenge once another Squad member has joined." title:@"" controller:self haveToPop:NO];
    }
}
- (IBAction)chatPressed:(UIButton *)sender {
    return;
//    [Utility msg:@"Coming soon" title:@"" controller:self haveToPop:NO];
//    return;
    NSDictionary *temp = [challengeArray objectAtIndex:[sender.accessibilityHint intValue]];
    NSArray *chlngArray = temp[@"challenge"];
    temp = chlngArray[sender.tag];
    if (![Utility isEmptyCheck:temp[@"JoinMember"]]) {
        if ([temp[@"JoinMember"]intValue] <= 1) {
            [Utility msg:@"This challenge has only 1 participant." title:@"" controller:self haveToPop:NO];
        } else {
            [self getChatData:temp[@"TaskId"]];
        }
    }
}
- (IBAction)remainderPressed:(UIButton *)sender {
    NSDictionary *temp = [challengeArray objectAtIndex:[sender.accessibilityHint intValue]];
    NSArray *chlngArray = temp[@"challenge"];
    temp = chlngArray[sender.tag];
    
    BOOL hasReminder = false;
    if(![Utility isEmptyCheck:[temp objectForKey:@"HasReminder"]]) {
        if ([[temp objectForKey:@"HasReminder"]boolValue]) {
            hasReminder = true;
        }
    }
    if (hasReminder) {
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:nil
                                              message:nil
                                              preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:@"Edit Reminder"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       [self reminderAction:temp sendData:YES];
                                   }];
        UIAlertAction *turnOff = [UIAlertAction
                                       actionWithTitle:@"Turn Off Reminder"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction *action)
                                       {
                                           NSMutableDictionary *rslt = [temp mutableCopy];
                                           NSMutableDictionary *pureDictionary = [NSMutableDictionary new];
                                           [rslt setObject:[NSNumber numberWithBool:false] forKey:@"Reminder"];
                                           [rslt removeObjectForKey:@"HasReminder"];
                                           for (NSString * key in [rslt allKeys])
                                           {
                                               if (![[rslt objectForKey:key] isKindOfClass:[NSNull class]])
                                                   [pureDictionary setObject:[rslt objectForKey:key] forKey:key];
                                           }
                                           [pureDictionary setObject:[NSNumber numberWithBool:false] forKey:@"Notification"];
                                           [self updatePersonalChallengeReminder:pureDictionary];
                                       }];
        UIAlertAction *cancelAction = [UIAlertAction
                                       actionWithTitle:@"Cancel"
                                       style:UIAlertActionStyleCancel
                                       handler:^(UIAlertAction *action)
                                       {
                                           
                                       }];
        [alertController addAction:okAction];
        [alertController addAction:turnOff];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    } else {
        [self reminderAction:temp sendData:NO];//no
    }
}
-(void)reminderAction:(NSDictionary *)temp sendData:(BOOL)sendData{
    NSMutableDictionary *pureDictionary = [NSMutableDictionary new];
    for (NSString * key in [temp allKeys])
    {
        if (![[temp objectForKey:key] isKindOfClass:[NSNull class]])
            [pureDictionary setObject:[temp objectForKey:key] forKey:key];
    }
    
    if (sendData){
        [pureDictionary setObject:[NSNumber numberWithBool:[[pureDictionary objectForKey:@"Notification"]boolValue]] forKey:@"PushNotification"];
    }else{
        [pureDictionary setObject:[NSNumber numberWithBool:true] forKey:@"PushNotification"];
    }
    activeDict = pureDictionary;
    SetReminderViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SetReminder"];
//    if (sendData){
        controller.defaultSettingsDict = activeDict;
//    }
    controller.reminderDelegate = self;
    controller.fromController = @"PersonalChallenge";
    //gami_badge_popup
    if (isFirstTimeReminderSet) {
        controller.isFirstTime = isFirstTimeReminderSet;
        isFirstTimeReminderSet = false;
    }//gami_badge_popup
    controller.view.backgroundColor = [UIColor clearColor];
    controller.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:controller animated:YES completion:nil];
}
- (IBAction)deletePressed:(UIButton *)sender {
    {
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Alert!"
                                      message:@"Do you want to delete this Personal challenge ?"
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"Yes"
                             style:UIAlertActionStyleDestructive
                             handler:^(UIAlertAction * action)
                             {
                                 NSDictionary *temp = [self->challengeArray objectAtIndex:[sender.accessibilityHint intValue]];
                                 NSArray *chlngArray = temp[@"challenge"];
                                 temp = chlngArray[sender.tag];
                                 if ([temp[@"IsSquadCreated"]boolValue]) {
                                     [self deleteMyChallenge:temp[@"HabitId"] tag:sender.tag outerTag:[sender.accessibilityHint intValue]];
                                 }else if ([temp[@"JoinMember"]intValue]>1 && ([temp[@"ParentActionUserId"] integerValue] == [[defaults objectForKey:@"UserID"] integerValue])) {
                                     [Utility msg:@"You can not delete a challenge once another squad member has joined." title:@"" controller:self haveToPop:NO];
                                 } else {
                                     [self deleteMyChallenge:temp[@"HabitId"] tag:sender.tag outerTag:[sender.accessibilityHint intValue]];
                                 }
                             }];
        UIAlertAction* cancel = [UIAlertAction
                                 actionWithTitle:@"No"
                                 style:UIAlertActionStyleCancel
                                 handler:^(UIAlertAction * action)
                                 {
                                     
                                 }];
        
        [alert addAction:ok];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
}
- (IBAction)sharePressed:(UIButton *)sender {
    //if active false do nothing
    return;
    NSDictionary *temp = [challengeArray objectAtIndex:[sender.accessibilityHint intValue]];
//    NSArray *chlngArray = temp[@"challenge"];
//    NSDictionary *challengeDict = chlngArray[sender.tag];
    if ([temp[@"active"] intValue] == 1) {
        shareView.tag = sender.tag;
        shareView.accessibilityHint = sender.accessibilityHint;
        shareView.hidden = false;
    }
}
- (IBAction)showParticipants:(UIButton *)sender {
    NSDictionary *temp = [challengeArray objectAtIndex:[sender.accessibilityHint intValue]];
    NSArray *chlngArray = temp[@"challenge"];
    temp = chlngArray[sender.tag];
    if (![Utility isEmptyCheck:temp[@"JoinMember"]]) {
        if ([temp[@"JoinMember"] intValue] > 1) {
            [self showParticipantList:temp[@"HabitId"]];
        } else {
//            [Utility msg:@"This challenge has only you as a participant." title:@"" controller:self haveToPop:NO];
        }
    }
}
- (IBAction)crossButtonPressed:(UIButton *)sender {
    userListView.hidden = true;
    shareView.hidden = true;
}
- (IBAction)shareWithFbOrBuddyPressed:(UIButton *)sender {
    //get shareView tag and accessibilityhint
    if (sender.tag == 1) {
        //facebook
    }else if (sender.tag == 2) {
        //buddy
    }
}
- (IBAction)joinPressed:(UIButton *)sender {
    NSDictionary *temp = [challengeArray objectAtIndex:[sender.accessibilityHint intValue]];
    NSArray *chlngArray = temp[@"challenge"];
    temp = chlngArray[sender.tag];
    [self joinSquadChallenge:temp[@"ActionId"] isSquadCreated:[temp[@"IsSquadCreated"]boolValue]];
}
- (IBAction)showCompletedPressed:(UIButton *)sender {
    showCompleted = !showCompleted;
    [challengeTable reloadData];
}

#pragma mark -End

#pragma mark -Private Method

-(void)getPersonalChallenge:(BOOL)isActive myPersonal:(BOOL)myPersonal{
    if (Utility.reachable) {
        challengeTable.hidden = true;
        if (isActive) {
            [challengeArray removeAllObjects];
        }
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults objectForKey:@"UserID"] forKey:@"userId"];
        [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:[NSNumber numberWithBool:isActive] forKey:@"Active"];
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            self->apiCount++;
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
            self->contentView = [Utility activityIndicatorView:self];
        });
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        NSString *apiName;
        if (myPersonal) {
            apiName = @"GetMyPersonalChallenge";
        } else {
            apiName = @"GetPersonalChallenge";
        }
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:apiName append:@""forAction:@"POST"];
        
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 self->apiCount--;
                                                                 if (self->contentView && self->apiCount == 0){
                                                                     [self->contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"SuccessFlag"]boolValue]) {
                                                                         BOOL active = isActive;
                                                                         if (active && self->myChallengeButton.isSelected) {
                                                                             if (![Utility isEmptyCheck:responseDict[@"Details"]]) {
                                                                                 NSMutableDictionary *dict = [NSMutableDictionary new];
                                                                                 [dict setObject:@1 forKey:@"active"];
                                                                                 NSArray *temp = responseDict[@"Details"];
                                                                                 NSMutableArray *sortedArray = [NSMutableArray new];
                                                                                 NSDate *date = [NSDate date];
                                                                                 NSDateFormatter *formatter = [NSDateFormatter new];
                                                                                 [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
                                                                                 NSString *sDate = [formatter stringFromDate:date];
                                                                                 
                                                                                 NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(CreatedAt < %@)",sDate];
                                                                                 NSArray *nextArray = [temp filteredArrayUsingPredicate:predicate];
                                                                                 NSSortDescriptor *sortByDate = [NSSortDescriptor sortDescriptorWithKey:@"Enddate" ascending:NO];
                                                                                 NSArray *sortDescriptors = @[sortByDate];
                                                                                 nextArray = [nextArray sortedArrayUsingDescriptors:sortDescriptors];
                                                                                 [sortedArray addObjectsFromArray:[nextArray mutableCopy]];
                                                                                 
                                                                                 predicate = [NSPredicate predicateWithFormat:@"(CreatedAt > %@)",sDate];
                                                                                 [sortedArray addObjectsFromArray:[[temp filteredArrayUsingPredicate:predicate]mutableCopy]];
                                                                                 
                                                                                 [dict setObject:sortedArray forKey:@"challenge"];
                                                                                 
                                                                                 [self->challengeArray addObject:dict];
                                                                             }
                                                                             [self getPersonalChallenge:false myPersonal:myPersonal];
                                                                             return;
                                                                         } else {
                                                                             if (![Utility isEmptyCheck:responseDict[@"Details"]]) {
                                                                                 NSMutableDictionary *dict = [NSMutableDictionary new];
                                                                                 NSArray *temp = responseDict[@"Details"];
                                                                                 [dict setObject:@0 forKey:@"active"];
                                                                                 [dict setObject:[temp mutableCopy] forKey:@"challenge"];
                                                                                 [self->challengeArray addObject:dict];
                                                                             }
                                                                             active = false;
                                                                         }
                                                                         if (!active && self->challengeArray.count>0) {
                                                                             self->firstTimeApiLoad = false;
                                                                             self->noDataLabel.hidden = true;
                                                                             self->challengeTable.hidden = false;
                                                                             [self generateNotification];
                                                                             [self->challengeTable reloadData];
                                                                             
                                                                             @try {
                                                                                 NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                                                                                 [self->challengeTable scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
                                                                             } @catch (NSException *exception) {
                                                                                 NSLog(@"error -> %@",exception);
                                                                             }
                                                                             
                                                                         }else if(self->challengeArray.count == 0){
                                                                             if (self->firstTimeApiLoad && myPersonal) {
                                                                                 self->firstTimeApiLoad = false;
                                                                                 
                                                                                 [self->challengeListButton sendActionsForControlEvents:UIControlEventTouchUpInside];
                                                                             }else{
                                                                                 self->noDataLabel.hidden = false;
                                                                                 self->challengeTable.hidden = true;
                                                                             }
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
-(void)generateNotification{
    
    NSArray *requests = [[UIApplication sharedApplication] scheduledLocalNotifications];
    for (UILocalNotification *req in requests) {
        NSString *pushTo = [req.userInfo objectForKey:@"pushTo"];
        if ([pushTo caseInsensitiveCompare:@"PersonalChallenge"] == NSOrderedSame) {
            [[UIApplication sharedApplication] cancelLocalNotification:req];
        }
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"active == 1"];
    NSArray *filteredArray = [challengeArray filteredArrayUsingPredicate:predicate];
    if (![Utility isEmptyCheck: filteredArray]) {
        NSDictionary *dict = [filteredArray objectAtIndex:0];
        filteredArray = [dict objectForKey:@"challenge"];
        if (![Utility isEmptyCheck:filteredArray]) {
            for (int i = 0; i < filteredArray.count; i++) {
                NSDictionary *detailsDict = [[NSDictionary alloc] initWithDictionary:[filteredArray objectAtIndex:i]];
                NSMutableDictionary *pureDictionary = [NSMutableDictionary new];
                for (NSString * key in [detailsDict allKeys])
                {
                    if (![Utility isEmptyCheck:[detailsDict objectForKey:key]])
                        [pureDictionary setObject:[detailsDict objectForKey:key] forKey:key];
                }
                detailsDict = pureDictionary;
                if (![Utility isEmptyCheck:[detailsDict objectForKey:@"HasReminder"]]?[[detailsDict objectForKey:@"HasReminder"] boolValue]:false) {
                    
                    NSMutableDictionary *extraData = [[NSMutableDictionary alloc] init];
                    [extraData setObject:detailsDict forKey:@"selectedChallangeDict"];
                    [extraData setObject:[detailsDict objectForKey:@"HabitId"] forKey:@"Id"];
                    [SetReminderViewController setOldLocalNotificationFromDictionary:[detailsDict mutableCopy] ExtraData:extraData FromController:(NSString *)@"PersonalChallenge" Title:[detailsDict objectForKey:@"HabitName"] Type:@"PersonalChallenge" Id:[[detailsDict objectForKey:@"HabitId"] intValue]];
                }
            }
        }
        
    }
    
}
- (void)toggleVisibleApiCall:(NSNumber *) habitId{
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self->apiCount++;
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
        [mainDict setObject:habitId forKey:@"HabitId"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"ToggleChallengeShareStatus" append:@""forAction:@"POST"];
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
                                                                          if (self->myChallengeButton.isSelected) {
                                                                              [self getPersonalChallenge:true myPersonal:true];
                                                                          } else {
                                                                              [self getPersonalChallenge:true myPersonal:false];
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
- (void)showParticipantList:(NSNumber *) challengeId{
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self->apiCount++;
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
        [mainDict setObject:challengeId forKey:@"ChallengeId"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetParticipantsList" append:@""forAction:@"POST"];
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
                                                                          if (![Utility isEmptyCheck:[responseDict objectForKey:@"Detail"]]) {
                                                                              self->userList = [responseDict objectForKey:@"Detail"];
                                                                              self->userListView.hidden = false;
                                                                              [self->userTable reloadData];
                                                                          }else{
                                                                              [Utility msg:@"Some error occur please try again later" title:@"" controller:self haveToPop:NO];
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
- (void)deleteMyChallenge:(NSNumber *) challengeId tag:(long)tag outerTag:(int)outerTag{
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self->apiCount++;
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
        [mainDict setObject:challengeId forKey:@"ChallengeId"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"DeleteMyChallenge" append:@""forAction:@"POST"];
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
                                                                          NSMutableDictionary *temp = [self->challengeArray objectAtIndex:outerTag];
                                                                          NSMutableArray *chlngArray = temp[@"challenge"];
                                                                          NSDictionary *tmpDict = chlngArray[tag];
                                                                          [chlngArray removeObject:tmpDict];
                                                                          if (chlngArray.count>0) {
                                                                              [temp setObject:chlngArray forKey:@"challenge"];
                                                                              [self->challengeArray replaceObjectAtIndex:outerTag withObject:temp];
                                                                          }else{
                                                                              [self->challengeArray removeObjectAtIndex:outerTag];
                                                                          }
                                                                          if (self->challengeArray.count>0) {
                                                                              self->challengeTable.hidden = false;
                                                                              self->noDataLabel.hidden = true;
                                                                              [self->challengeTable reloadData];
                                                                          } else {
                                                                              self->challengeTable.hidden = true;
                                                                              self->noDataLabel.hidden = false;
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
- (void)getChatData:(NSNumber *) challengeId{
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self->apiCount++;
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
//        [mainDict setObject:[defaults objectForKey:@"UserID"] forKey:@"UserID"];
        [mainDict setObject:challengeId forKey:@"ChallengeId"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetChatData" append:@""forAction:@"POST"];
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
                                                                          NSLog(@"chat details:\n\n\n%@", responseDict);
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
- (void)updatePersonalChallengeReminder:(NSDictionary *) detailsDict{
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self->apiCount++;
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
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"AbbbcUserSessionId"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"AbbbcUserId"];
        [mainDict setObject:detailsDict forKey:@"Details"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"UpdatePersonalChallengeReminder" append:@""forAction:@"POST"];
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
//                                                                          NSMutableDictionary *extraData = [[NSMutableDictionary alloc] init];
//                                                                          [extraData setObject:detailsDict forKey:@"selectedChallangeDict"];
//                                                                          [extraData setObject:[self->activeDict objectForKey:@"HabitId"] forKey:@"Id"];
//                                                                          [SetReminderViewController setOldLocalNotificationFromDictionary:[detailsDict mutableCopy] ExtraData:extraData FromController:(NSString *)@"PersonalChallenge" Title:[self->activeDict objectForKey:@"HabitName"] Type:@"PersonalChallenge" Id:[[self->activeDict objectForKey:@"HabitId"] intValue]];
                                                                          if (self->myChallengeButton.isSelected) {
                                                                              [self getPersonalChallenge:true myPersonal:true];
                                                                          } else {
                                                                              [self getPersonalChallenge:true myPersonal:false];
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
- (void)joinSquadChallenge:(NSNumber *) actionId isSquadCreated:(BOOL)isSquadCreated{
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self->apiCount++;
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
            self->contentView = [Utility activityIndicatorView:self];
        });
        NSURLSession *customSession = [NSURLSession sharedSession];
        NSError *error;
        
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults objectForKey:@"UserID"] forKey:@"UserId"];
        [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"AbbbcUserSessionId"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"AbbbcUserId"];
        [mainDict setObject:actionId forKey:@"ChallengeId"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        NSString *apiName;
        if (isSquadCreated) {
            apiName = @"JoinSquadChallenge";
        } else {
            apiName = @"JoinChallenge";
        }
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
                                                                      if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"]boolValue]) {
                                                                          [self->myChallengeButton sendActionsForControlEvents:UIControlEventTouchUpInside];
//                                                                          if (self->myChallengeButton.isSelected) {
//                                                                              [self getPersonalChallenge:true myPersonal:true];
//                                                                          } else {
//                                                                              [self getPersonalChallenge:true myPersonal:false];
//                                                                          }
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
#pragma mark -End

#pragma mark -TableView Delegate & Datasource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (myChallengeButton.isSelected && tableView == challengeTable) {
        NSDictionary *temp = challengeArray[section];
        if([temp[@"active"]  isEqual: @0]) {
            return 40.0;
        }else{
            return CGFLOAT_MIN;
        }
    }else{
        return CGFLOAT_MIN;
    }
}
-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (myChallengeButton.isSelected && tableView == challengeTable) {
        NSDictionary *temp = challengeArray[section];
        if([temp[@"active"]  isEqual: @0]) {
            PersonalChallengeHeaderView *sectionHeaderView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"PersonalChallengeHeaderView"];
            [sectionHeaderView.headerButton addTarget:self action:@selector(showCompletedPressed:) forControlEvents:UIControlEventTouchUpInside];
            if (showCompleted) {
                sectionHeaderView.headerText.text = @"HIDE COMPLETED CHALLENGES";
            }else{
                sectionHeaderView.headerText.text = @"VIEW COMPLETED CHALLENGES";
            }
            return  sectionHeaderView;
        }else{
            return nil;
        }
    }
    
    return nil;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == challengeTable) {
//        if (myChallengeButton.isSelected) {
//            if (showCompleted) {
//                return challengeArray.count;
//            } else {
//                NSInteger section = 0;
//                for (NSDictionary *temp in challengeArray) {
//                    if ([temp[@"active"]  isEqual: @1]) {
//                        section++;
//                    }else if ([temp[@"active"]  isEqual: @0]) {
//                        section++;
//                    }
//                }
//                return section;
//            }
//        } else {
//            return challengeArray.count;
//        }
        return challengeArray.count;
    } else {
        return 1;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == challengeTable) {
        if (myChallengeButton.isSelected) {
            if (showCompleted) {
                NSDictionary *temp = challengeArray[section];
                NSArray *chlngArray = temp[@"challenge"];
                return chlngArray.count;
            } else {
                NSDictionary *temp = challengeArray[section];
                if ([temp[@"active"]  isEqual: @1]) {
                    NSArray *chlngArray = temp[@"challenge"];
                    return chlngArray.count;
                }else{
                    return 0;
                }
            }
        }else{
            NSDictionary *temp = challengeArray[section];
            NSArray *chlngArray = temp[@"challenge"];
            return chlngArray.count;
        }
        
    } else {
        return userList.count;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *tableCell;
    PersonalChallengeTableViewCell *cell = (PersonalChallengeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"PersonalChallengeTableViewCell"];
    
    if (tableView == challengeTable) {
        if (myChallengeButton.isSelected) {
            cell = (PersonalChallengeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"PersonalChallengeTableViewCellMyChlng"];
        }else{
            cell = (PersonalChallengeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"PersonalChallengeTableViewCell"];
        }
        if (challengeArray.count>0) {
            NSDictionary *dict = challengeArray[indexPath.section];
            NSArray *detailsArray = dict[@"challenge"];
            NSDictionary *challengeDict = detailsArray[indexPath.row];
            
            cell.challengeName.text = ![Utility isEmptyCheck:challengeDict[@"HabitName"]]?challengeDict[@"HabitName"]:@"";
            
            NSDateFormatter *df = [NSDateFormatter new];
            [df setDateFormat:@"yyyy-MM-dd"];
            NSDate *today = [df dateFromString:[df stringFromDate:[NSDate date]]];
            [df setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
            NSDate *date = [df dateFromString:challengeDict[@"CreatedAt"]];
            [df setDateFormat:@"EEEE dd/MM/yyyy"];
            NSString *strDate = [df stringFromDate:date];
            cell.startedOnLabel.text = ![Utility isEmptyCheck:strDate]?[NSString stringWithFormat:@"%@",strDate]:@"";
            
            [df setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
            date = [df dateFromString:challengeDict[@"Enddate"]];
            [df setDateFormat:@"EEEE dd/MM/yyyy"];
            strDate = [df stringFromDate:date];
            cell.endsOnLabel.text = ![Utility isEmptyCheck:strDate]?[NSString stringWithFormat:@"%@",strDate]:@"";
            
            cell.descriptionLabel.text = ![Utility isEmptyCheck:challengeDict[@"Description"]]?[NSString stringWithFormat:@"%@",challengeDict[@"Description"]]:@"";
            
            NSDateComponents *components;
            NSInteger days;
            
            if (myChallengeButton.isSelected) {
                NSInteger parentActionUserId = ![Utility isEmptyCheck:challengeDict[@"ParentActionUserId"]]?[challengeDict[@"ParentActionUserId"] integerValue]:0;
                
                if ([challengeDict[@"IsSquadCreated"]boolValue] || (parentActionUserId != [[defaults objectForKey:@"UserID"] integerValue])) {
                    cell.publicButton.hidden = true;
                } else {
                    cell.publicButton.hidden = false;
                }
                NSNumber *share = ![Utility isEmptyCheck:challengeDict[@"Shareable"]]?challengeDict[@"Shareable"]:@1;
                
//                cell.publicButton.selected = [share boolValue];
                cell.publicButton.layer.masksToBounds = YES;
                cell.publicButton.layer.cornerRadius = cell.publicButton.frame.size.height / 2;
                if (![Utility isEmptyCheck:challengeDict[@"HasReminder"]] && [challengeDict[@"HasReminder"] boolValue]) {
                    [cell.remainderButton setImage:[UIImage imageNamed:@"clockPersonal_green.png"] forState:UIControlStateNormal];
                } else {
                    [cell.remainderButton setImage:[UIImage imageNamed:@"clockPersonal.png"] forState:UIControlStateNormal];
                }
                if ([dict[@"active"]  isEqual: @1]) {
                    cell.remainderButton.hidden = false;
                    if ([challengeDict[@"JoinMember"]intValue]>1 && (parentActionUserId == [[defaults objectForKey:@"UserID"] integerValue])) {
                        cell.deleteButton.hidden = true;
                    }else{
                        cell.deleteButton.hidden = false;
                    }
                    [cell.challengeName setTextColor:[UIColor colorWithRed:(228/255.0f) green:(39/255.0f) blue:(160/255.0f) alpha:1.0f]];
                    [cell.start setTextColor:[UIColor colorWithRed:(228/255.0f) green:(39/255.0f) blue:(160/255.0f) alpha:1.0f]];
                    [cell.end setTextColor:[UIColor colorWithRed:(228/255.0f) green:(39/255.0f) blue:(160/255.0f) alpha:1.0f]];
                    if ([share boolValue]) {
                        [cell.publicButton setImage:[UIImage imageNamed:@"public.png"] forState:UIControlStateNormal];
                    } else {
                        [cell.publicButton setImage:[UIImage imageNamed:@"private.png"] forState:UIControlStateNormal];
                    }
                    cell.vertDivider.hidden = false;
                    cell.fStackView.hidden = false;
                }else{
                    cell.remainderButton.hidden = true;
                    cell.deleteButton.hidden = true;
                    [cell.challengeName setTextColor:[UIColor colorWithRed:(88/255.0f) green:(88/255.0f) blue:(91/255.0f) alpha:1.0f]];
                    [cell.start setTextColor:[UIColor colorWithRed:(88/255.0f) green:(88/255.0f) blue:(91/255.0f) alpha:1.0f]];
                    [cell.end setTextColor:[UIColor colorWithRed:(88/255.0f) green:(88/255.0f) blue:(91/255.0f) alpha:1.0f]];
                    if ([share boolValue]) {
                        [cell.publicButton setImage:[UIImage imageNamed:@"public_inactive.png"] forState:UIControlStateNormal];
                    } else {
                        [cell.publicButton setImage:[UIImage imageNamed:@"private_inactive.png"] forState:UIControlStateNormal];
                    }
                    cell.vertDivider.hidden = true;
                    cell.fStackView.hidden = true;
                }
                
                cell.shareButton.hidden = ![share boolValue];
                [cell.participantButton setTitle:![Utility isEmptyCheck:challengeDict[@"JoinMember"]]?[NSString stringWithFormat:@"%@ PARTICIPANTS",challengeDict[@"JoinMember"]]:@"1 PARTICIPANTS" forState:UIControlStateNormal];
                
                
//                cell.daysLeftLabel.layer.borderWidth = 1;
//                cell.daysLeftLabel.layer.borderColor = [UIColor colorWithRed:88/255.0f green:88/255.0f blue:88/255.0f alpha:1.0f].CGColor;
//                cell.challengeCompletedLabel.layer.borderWidth = 1;
//                cell.challengeCompletedLabel.layer.borderColor = [UIColor colorWithRed:88/255.0f green:88/255.0f blue:88/255.0f alpha:1.0f].CGColor;
                
                [df setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
                date = [df dateFromString:challengeDict[@"CreatedAt"]];
                
                cell.completedDates.hidden = true;
                if ([date isToday] || [date isEarlierThan:today]){
                    //today or past start date
                    if ([dict[@"active"]  isEqual: @1]) {
                        [cell.challengeName setTextColor:[UIColor colorWithRed:(76/255.0f) green:(217/255.0f) blue:(100/255.0f) alpha:1.0f]];
                    }
                    date = [df dateFromString:challengeDict[@"Enddate"]];
                    components = [[NSCalendar currentCalendar] components: NSCalendarUnitDay fromDate: today toDate: date options: 0];
                    days = [components day];
//                    if ([date isToday]) {
//                        days = -1;
//                    }
                    cell.daysLeftLabel.text = [NSString stringWithFormat:@"%ld DAYS TO GO",(long)days];
                    [cell.daysLeftLabel setFont:[UIFont fontWithName:@"Oswald-Light" size:16.0]];
                    cell.challengeCompletedLabel.hidden = false;
                    
                    components = [[NSCalendar currentCalendar] components: NSCalendarUnitDay fromDate: [df dateFromString:challengeDict[@"CreatedAt"]] toDate: today options: 0];
                    days = [components day];
                    days = days+1;
                    int percent = 0;
                    if (days != 0) {
                        percent = [challengeDict[@"CheckDone"]intValue] * 100.0 / days;
                    }
//                    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"YOU'VE COMPLETED %@ ACTION",challengeDict[@"CheckDone"]]];
                    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@/%ld ( %d%% )",challengeDict[@"CheckDone"],(long)days,percent]];
                    NSRange foundRange = [text.mutableString rangeOfString:[NSString stringWithFormat:@"%@ ACTION",challengeDict[@"CheckDone"]]];
                    
                    NSDictionary *attrDict = @{
                                               NSFontAttributeName : [UIFont fontWithName:@"Oswald-Light" size:16.0],
                                               NSForegroundColorAttributeName : [UIColor colorWithRed:(88/255.0f) green:(88/255.0f) blue:(91/255.0f) alpha:1.0f]
                                               
                                               };
                    [text addAttributes:attrDict range:NSMakeRange(0, text.length)];
                    [text addAttributes:@{
                                          NSFontAttributeName : [UIFont fontWithName:@"Oswald-Light" size:16.0],
                                          NSForegroundColorAttributeName : [UIColor colorWithRed:(228/255.0f) green:(39/255.0f) blue:(160/255.0f) alpha:1.0f]
                                          
                                          }
                                  range:foundRange];
                    
                    if ([[df dateFromString:challengeDict[@"CreatedAt"]] isEarlierThanOrEqualTo:today] && [today isEarlierThanOrEqualTo:[df dateFromString:challengeDict[@"Enddate"]]]) {
                        components = [[NSCalendar currentCalendar] components: NSCalendarUnitDay fromDate: [df dateFromString:challengeDict[@"CreatedAt"]] toDate: [NSDate date] options: 0];
                        days = [components day];
                        cell.challengeCompletedLabel.attributedText = text;///%ld",challengeDict[@"CheckDone"],(long)days+1];
                        cell.challengeCompletedLabel.hidden = false;
                        
                        date = [df dateFromString:challengeDict[@"CreatedAt"]];
                        components = [[NSCalendar currentCalendar] components: NSCalendarUnitDay fromDate: date toDate: today options: 0];
                        days = [components day];
                        NSMutableAttributedString *text1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"YOU'RE %ld DAYS INTO THE CHALLENGE",(long)days]];
                        NSDictionary *attrDict = @{
                                                   NSFontAttributeName : [UIFont fontWithName:@"Oswald-Light" size:16.0],
                                                   NSForegroundColorAttributeName : [UIColor colorWithRed:(88/255.0f) green:(88/255.0f) blue:(91/255.0f) alpha:1.0f]
                                                   };
                        [text1 addAttributes:attrDict range:NSMakeRange(0, text1.length)];
                        
                        NSRange foundRange = [text1.mutableString rangeOfString:[NSString stringWithFormat:@"%ld DAYS",(long)days]];
                        [text1 addAttributes:@{
                                               NSForegroundColorAttributeName : [UIColor colorWithRed:(228/255.0f) green:(39/255.0f) blue:(160/255.0f) alpha:1.0f]
                                               }
                                       range:foundRange];
                        
                        cell.completedDates.attributedText = text1;
                        cell.completedDates.hidden = false;
                    }else if ([[df dateFromString:challengeDict[@"CreatedAt"]] isEarlierThanOrEqualTo:[df dateFromString:challengeDict[@"Enddate"]]] && [[df dateFromString:challengeDict[@"Enddate"]] isEarlierThanOrEqualTo:today]){
                        components = [[NSCalendar currentCalendar] components: NSCalendarUnitDay fromDate: [df dateFromString:challengeDict[@"CreatedAt"]] toDate: [df dateFromString:challengeDict[@"Enddate"]] options: 0];
                        days = [components day];
                        days = days+1;
                        int percent = 0;
                        if (days != 0) {
                            percent = [challengeDict[@"CheckDone"]intValue] * 100.0 / days;
                        }
                        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@/%ld ( %d%% )",challengeDict[@"CheckDone"],(long)days,percent]];
                        NSRange foundRange = [text.mutableString rangeOfString:[NSString stringWithFormat:@"%@ ACTION",challengeDict[@"CheckDone"]]];
                        
                        NSDictionary *attrDict = @{
                                                   NSFontAttributeName : [UIFont fontWithName:@"Oswald-Light" size:16.0],
                                                   NSForegroundColorAttributeName : [UIColor colorWithRed:(88/255.0f) green:(88/255.0f) blue:(91/255.0f) alpha:1.0f]
                                                   
                                                   };
                        [text addAttributes:attrDict range:NSMakeRange(0, text.length)];
                        [text addAttributes:@{
                                              NSFontAttributeName : [UIFont fontWithName:@"Oswald-Light" size:16.0],
                                              NSForegroundColorAttributeName : [UIColor colorWithRed:(228/255.0f) green:(39/255.0f) blue:(160/255.0f) alpha:1.0f]
                                              
                                              }
                                      range:foundRange];
                        cell.challengeCompletedLabel.attributedText = text;
                        cell.challengeCompletedLabel.hidden = false;
                    }
                    
                }else{
                    //future start date
                    date = [df dateFromString:challengeDict[@"CreatedAt"]];
                    components = [[NSCalendar currentCalendar] components: NSCalendarUnitDay fromDate: today toDate: date options: 0];
                    days = [components day];
                    
                    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"WE START IN %ld DAYS",(long)days]];
                    NSRange foundRange = [text.mutableString rangeOfString:[NSString stringWithFormat:@"%ld DAYS",(long)days]];
                    
                    NSDictionary *attrDict = @{
                                               NSFontAttributeName : [UIFont fontWithName:@"Oswald-Light" size:16.0],
                                               NSForegroundColorAttributeName : [UIColor colorWithRed:(88/255.0f) green:(88/255.0f) blue:(91/255.0f) alpha:1.0f]
                                               
                                               };
                    [text addAttributes:attrDict range:NSMakeRange(0, text.length)];
                    [text addAttributes:@{
                                          NSFontAttributeName : [UIFont fontWithName:@"Oswald-Light" size:16.0],
                                          NSForegroundColorAttributeName : [UIColor colorWithRed:(228/255.0f) green:(39/255.0f) blue:(160/255.0f) alpha:1.0f]
                                          
                                          }
                                  range:foundRange];
                    
                    cell.daysLeftLabel.attributedText = text;
                    cell.challengeCompletedLabel.hidden = true;
                }
                if ([dict[@"active"]  isEqual: @0]) {
                    cell.daysLeftLabel.hidden = true;
                }else{
                    cell.daysLeftLabel.hidden = false;
                }
                
                cell.shareButton.hidden = false;
                cell.chatButton.hidden = false;
                cell.completedDates.hidden = true;
            } else {
                [df setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
//                date = [df dateFromString:challengeDict[@"CreatedAt"]];
//                [df setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
//                date = [df dateFromString:challengeDict[@"Enddate"]];
                cell.daysLeftLabel.hidden = false;
                components = [[NSCalendar currentCalendar] components: NSCalendarUnitDay fromDate: [df dateFromString:challengeDict[@"CreatedAt"]] toDate: [df dateFromString:challengeDict[@"Enddate"]] options: 0];
                days = [components day];
                cell.daysLeftLabel.text = [NSString stringWithFormat:@"%ld DAYS",(long)days];
                [cell.daysLeftLabel setFont:[UIFont fontWithName:@"Oswald-Regular" size:16.0]];
                cell.adminImage.hidden = ![challengeDict[@"IsSquadCreated"] boolValue];
                
//                if ([date isLaterThan:[NSDate date]]){
//                    //future start date
//                    components = [[NSCalendar currentCalendar] components: NSCalendarUnitDay fromDate: [NSDate date] toDate: date options: 0];
//                    days = [components day];
//                    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"WE START IN %ld DAYS",(long)days+1]];
//                    NSRange foundRange = [text.mutableString rangeOfString:[NSString stringWithFormat:@"%ld DAYS",(long)days+1]];
//
//                    NSDictionary *attrDict = @{
//                                               NSFontAttributeName : [UIFont fontWithName:@"Oswald-Light" size:14.0],
//                                               NSForegroundColorAttributeName : [UIColor colorWithRed:(88/255.0f) green:(88/255.0f) blue:(91/255.0f) alpha:1.0f]
//
//                                               };
//                    [text addAttributes:attrDict range:NSMakeRange(0, text.length)];
//                    [text addAttributes:@{
//                                          NSFontAttributeName : [UIFont fontWithName:@"Oswald-Light" size:14.0],
//                                          NSForegroundColorAttributeName : [UIColor colorWithRed:(228/255.0f) green:(39/255.0f) blue:(160/255.0f) alpha:1.0f]
//
//                                          }
//                                  range:foundRange];
//
//                    cell.daysLeftLabel.attributedText = text;
//
//                    cell.daysLeftLabel.hidden = false;
//                }else{
//                    cell.daysLeftLabel.hidden = true;
//                }
                
                cell.publicButton.hidden = true;
                cell.remainderButton.hidden = true;
                cell.deleteButton.hidden = true;
                cell.participantView.hidden = true;
                cell.challengeCompletedLabel.hidden = true;
                cell.shareButton.hidden = true;
                cell.chatButton.hidden = true;
                cell.joinButton.hidden = false;
                cell.completedDates.hidden = true;
//                cell.joinButton.layer.masksToBounds = YES;
//                cell.joinButton.layer.cornerRadius = cell.joinButton.frame.size.height / 3;
            }
            
            cell.joinButton.tag = indexPath.row;
            cell.joinButton.accessibilityHint = [NSString stringWithFormat:@"%d",(int)indexPath.section];
            cell.participantButton.tag = indexPath.row;
            cell.participantButton.accessibilityHint = [NSString stringWithFormat:@"%d",(int)indexPath.section];
            cell.publicButton.tag = indexPath.row;
            cell.publicButton.accessibilityHint = [NSString stringWithFormat:@"%d",(int)indexPath.section];
            cell.chatButton.tag = indexPath.row;
            cell.chatButton.accessibilityHint = [NSString stringWithFormat:@"%d",(int)indexPath.section];
            cell.remainderButton.tag = indexPath.row;
            cell.remainderButton.accessibilityHint = [NSString stringWithFormat:@"%d",(int)indexPath.section];
            cell.deleteButton.tag = indexPath.row;
            cell.deleteButton.accessibilityHint = [NSString stringWithFormat:@"%d",(int)indexPath.section];
            cell.shareButton.tag = indexPath.row;
            cell.shareButton.accessibilityHint = [NSString stringWithFormat:@"%d",(int)indexPath.section];
            
        }
        cell.shareButton.hidden = true;//delete this
        cell.chatButton.hidden = true;//delete this
        
        tableCell = cell;
    } else {
        NSDictionary *dict = userList[indexPath.row];
        cell.userName.text = ![Utility isEmptyCheck:dict[@"FullName"]]?dict[@"FullName"]:@"";
        [cell.userImage sd_setImageWithURL:[NSURL URLWithString:[[NSString stringWithFormat:@"%@%@",BASEIMAGE_URL,dict[@"Profilepic"]] stringByAddingPercentEncodingWithAllowedCharacters: [NSCharacterSet URLQueryAllowedCharacterSet]]] placeholderImage:[UIImage imageNamed:@"new_image_loading.png"] options:SDWebImageScaleDownLargeImages];
        cell.userImage.layer.masksToBounds = YES;
        cell.userImage.layer.cornerRadius = cell.userImage.frame.size.height / 2;

        tableCell = cell;
    }
    
    return tableCell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == challengeTable && myChallengeButton.isSelected) {
        NSDictionary *temp = challengeArray[indexPath.section];
        NSArray *chlngArray = temp[@"challenge"];
        temp = chlngArray[indexPath.row];
        NSLog(@"%@",temp);
        PersonalChallengeDetailsViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PersonalChallengeDetails"];
        controller.habitId = temp[@"HabitId"];//req
        controller.taskId = temp[@"TaskId"];
        controller.delegate = self;
        [self.navigationController pushViewController:controller animated:YES];
    }
}
#pragma mark -End

#pragma mark - ReminderDelegate
-(void) reminderSettingsValue:(NSMutableDictionary *)reminderDict {
    [reminderDict setObject:activeDict[@"HabitId"] forKey:@"HabitId"];
    
    [reminderDict setObject:[NSNumber numberWithBool:[[reminderDict objectForKey:@"PushNotification"]boolValue]] forKey:@"Notification"];
    [reminderDict removeObjectForKey:@"HasReminder"];
    [reminderDict setObject:[NSNumber numberWithBool:true] forKey:@"Reminder"];//HasReminder//Reminder
    [self updatePersonalChallengeReminder:reminderDict];
    // api call             //Id
    // and then in success
    /*{
     [resultDict setObject:[[responseDict objectForKey:@"Details"] objectForKey:@"id"] forKey:@"id"];
     NSMutableDictionary *extraData = [[NSMutableDictionary alloc] init];
     [extraData setObject:resultDict forKey:@"selectedGoalDict"];
     [extraData setObject:_valuesArray forKey:@"valuesArray"];
     [SetReminderViewController setOldLocalNotificationFromDictionary:savedReminderDict ExtraData:extraData FromController:(NSString *)@"Goal" Title:titleTextView.text Type:@"Goal" Id:[[_selectedGoalDict objectForKey:@"id"] intValue]];
     }*/
}
-(void) cancelReminder {
//    if ([resultDict objectForKey:@"FrequencyId"] != nil) {
//
//    } else {
//        [setReminderSwitch setOn:NO];
//        [resultDict setObject:[NSNumber numberWithBool:NO] forKey:@"HasReminder"];
//        [resultDict removeObjectForKey:@"FrequencyId"];
//    }
//    [self prepareReminderView];
}
#pragma mark -End
#pragma mark -ViewwillAppear Load Delegate
-(void)didChangePersonalChallengeAddEdit:(BOOL)ischanged{
    isLoadController = ischanged;
}
-(void)didChangePersonalChallengeDetails:(BOOL)ischanged{
    isLoadController = ischanged;
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
