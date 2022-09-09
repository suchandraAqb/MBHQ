//
//  AddVitaminViewController.m
//  Squad
//
//  Created by AQB Solutions-Mac Mini 2 on 15/03/19.
//  Copyright © 2019 AQB Solutions. All rights reserved.
//

#import "AddVitaminViewController.h"
#import "DropdownViewController.h"
#import "AddVitaminTableViewCell.h"

@interface AddVitaminViewController ()
{
    IBOutlet UIButton *addOrEditMode;
    IBOutlet UITextField *vitaminNameTextField;
    IBOutlet UITextField *dailyAmountTextField;
    IBOutlet UITextField *amounttypeTextField;
    IBOutlet UISwitch *reminderSwitch;
    IBOutlet UIButton *deleteButton;
    IBOutlet UIButton *saveButton;
    IBOutlet UIScrollView *mainScroll;
    IBOutletCollection(UIButton) NSArray *daysButtons;
    IBOutlet UIButton *reminderTimeButton;
    IBOutlet UIButton *reminderAndTimeButton;
    IBOutlet UIView *editLabelView;
    IBOutlet UIButton *timesPerDayButton;
    IBOutlet UIButton *amountTypeButton;
    IBOutlet UITextField *tabletPerTimeTextField;
    IBOutlet UITableView *gpReminderDetailsTable;
    IBOutlet UIView *gpReminderView;
    NSMutableArray *reminderTimeArray;
    NSMutableDictionary *resultDict;
    NSArray *dayArray;
    UITextField *activeTextField;
    UIToolbar *toolBar;
    UITextView *activeTextView;
    NSMutableArray *nameArray;
    UIView *contentView;
    NSArray *amountTypeArr;
    int selectedIndex;
    int amountIndex;
    NSArray *grouplistArray;
    BOOL isgroup;
    NSString *vitaminStr;
}
@end

@implementation AddVitaminViewController
@synthesize addVitaminDelegate;
#pragma mark  - View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    gpReminderDetailsTable.estimatedRowHeight = 50;
    gpReminderDetailsTable.rowHeight = UITableViewAutomaticDimension;
    if (_isFromEdit) {
        editLabelView.hidden = false;
        deleteButton.hidden = false;
    }else{
        editLabelView.hidden = true;
        deleteButton.hidden = true;
    }
    [self webSerViceCall_GetUserVitaminGroups];
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

#pragma mark  - End

#pragma mark - IBAction
-(IBAction)deleteButtonPressed:(UIButton*)sender{
    [self webSerViceCall_DeleteUserVitamin];
}
-(IBAction)saveButtonPressed:(id)sender{
    if ([self validationCheck]) {
        [self webSerViceCall_AddUpdateUserVitamin];
    }
}
-(IBAction)cencelButtonPressed:(id)sender{
    [self.navigationController popViewControllerAnimated:NO];
}
-(IBAction)reminderValueChanged:(id)sender{
    if (reminderSwitch.isOn) {
        if ([Utility isEmptyCheck:[resultDict objectForKey:@"ReminderVitaminId"]] && grouplistArray.count>0) {
            [self reminderAlert];
        }
    else{
            SetReminderViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SetReminder"];
            if ([resultDict objectForKey:@"FrequencyId"] != nil)//FrequencyId
                controller.defaultSettingsDict = resultDict;
            controller.reminderDelegate = self;
            controller.fromController=@"Vitamin";
            controller.view.backgroundColor = [UIColor clearColor];
            controller.modalPresentationStyle = UIModalPresentationCustom;
            [self presentViewController:controller animated:YES completion:nil];
        }
    }
}
-(IBAction)reminderButtonTapped:(id)sender{
    DropdownViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Dropdown"];
    controller.modalPresentationStyle = UIModalPresentationCustom;
    controller.dropdownDataArray = reminderTimeArray;
    controller.sender = sender;
    controller.selectedIndex = (int)[reminderTimeArray indexOfObject:[sender currentTitle]];
    controller.delegate = self;
    [self presentViewController:controller animated:YES completion:nil];
}
-(IBAction)reminderAndTimeTapped:(id)sender{
    DropdownViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Dropdown"];
    controller.modalPresentationStyle = UIModalPresentationCustom;
    controller.dropdownDataArray = reminderTimeArray;
    controller.sender = sender;
    controller.selectedIndex = (int)[reminderTimeArray indexOfObject:[sender currentTitle]];
    controller.delegate = self;
    [self presentViewController:controller animated:YES completion:nil];
    
}
-(IBAction)frequencyButtonTapped:(UIButton*)sender{
    if (sender.selected) {
        sender.selected =false;
        [self changeButtonBackground:sender selected:false];
        [nameArray removeObject:[NSNumber numberWithInt:(int)sender.tag]];
    }else{
        sender.selected = true;
        [self changeButtonBackground:sender selected:true];
        [nameArray addObject:[NSNumber numberWithInt:(int)sender.tag]];
    }
}
-(IBAction)timesPerDayButtonTapped:(id)sender{
    DropdownViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Dropdown"];
    controller.modalPresentationStyle = UIModalPresentationCustom;
    controller.dropdownDataArray = @[@"1",@"2",@"3",@"4",@"5"];
    controller.mainKey = @"";
    controller.apiType = @"TimesPerDay";
    if (![Utility isEmptyCheck:timesPerDayButton.accessibilityHint]) {
        controller.selectedIndex = selectedIndex;
    }else{
        controller.selectedIndex = -1;
    }
    controller.delegate = self;
    [self presentViewController:controller animated:YES completion:nil];
}
-(IBAction)amountTypeButtonPressed:(id)sender{
    DropdownViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Dropdown"];
    controller.modalPresentationStyle = UIModalPresentationCustom;
    controller.dropdownDataArray = amountTypeArr;
    controller.mainKey = @"";
    controller.apiType = @"AmountType";
    if (![Utility isEmptyCheck:amountTypeButton.accessibilityHint]) {
        controller.selectedIndex = amountIndex;
    }else{
        controller.selectedIndex = -1;
    }
    controller.delegate = self;
    [self presentViewController:controller animated:YES completion:nil];
}
-(IBAction)cancelGpReminderView:(id)sender{
    gpReminderView.hidden= true;
}
#pragma mark - End

#pragma mark - WebService Call
-(void)webSerViceCall_AddUpdateUserVitamin{
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
        [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:AccessKey forKey:@"Key"];
        
        NSDateFormatter *df = [NSDateFormatter new];
        [df setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
        NSDateFormatter *df1 = [NSDateFormatter new];
        [df1 setDateFormat:@"yyyy-MM-dd"];
        NSString *dateStr = [df1 stringFromDate:[NSDate date]];

        if (![Utility isEmptyCheck:resultDict]) {
           [resultDict setObject:dateStr forKey:@"CreatedAtString"];
           [resultDict setObject:dateStr forKey:@"UpdatedAtString"];
           [resultDict setObject:[defaults objectForKey:@"UserID"] forKey:@"UserId"];
           [resultDict setObject:vitaminNameTextField.text forKey:@"VitaminName"];
           [resultDict setObject:[NSNumber numberWithInt:[timesPerDayButton.titleLabel.text intValue]] forKey:@"DailyAmount"];
           [resultDict setObject:[NSNumber numberWithInt:[tabletPerTimeTextField.text intValue]] forKey:@"TabletPerTime"];
            
           [resultDict setObject:[NSNumber numberWithInt:1] forKey:@"VitaminAmountTypeId"];
           [resultDict setObject:[NSNumber numberWithInt:1] forKey:@"TaskFrequencyTypeId"];
           [resultDict setObject:[resultDict objectForKey:@"FrequencyId"] forKey:@"ReminderFrequencyId"];
           [resultDict setObject:[NSNumber numberWithBool:YES] forKey:@"ReminderPushNotify"];
           [resultDict setObject:[resultDict objectForKey:@"Email"] forKey:@"ReminderEmail"];

           [resultDict setObject:[resultDict objectForKey:@"Sunday"] forKey:@"IsSundayTask"];
           [resultDict setObject:[resultDict objectForKey:@"Monday"] forKey:@"IsMondayTask"];
           [resultDict setObject:[resultDict objectForKey:@"Tuesday"] forKey:@"IsTuesdayTask"];
           [resultDict setObject:[resultDict objectForKey:@"Wednesday"] forKey:@"IsWednesdayTask"];
           [resultDict setObject:[resultDict objectForKey:@"Thursday"] forKey:@"IsThursdayTask"];
           [resultDict setObject:[resultDict objectForKey:@"Friday"] forKey:@"IsFridayTask"];
           [resultDict setObject:[resultDict objectForKey:@"Saturday"] forKey:@"IsSaturdayTask"];

            [resultDict setObject:[NSNumber numberWithBool:false] forKey:@"IsJanuaryTask"];
            [resultDict setObject:[NSNumber numberWithBool:false] forKey:@"IsFebruaryTask"];
            [resultDict setObject:[NSNumber numberWithBool:false] forKey:@"IsMarchTask"];
            [resultDict setObject:[NSNumber numberWithBool:false] forKey:@"IsAprilTask"];
            [resultDict setObject:[NSNumber numberWithBool:false] forKey:@"IsMayTask"];
            [resultDict setObject:[NSNumber numberWithBool:false] forKey:@"IsJuneTask"];
            [resultDict setObject:[NSNumber numberWithBool:false] forKey:@"IsJulyTask"];
            [resultDict setObject:[NSNumber numberWithBool:false] forKey:@"IsAugustTask"];
            [resultDict setObject:[NSNumber numberWithBool:false] forKey:@"IsSeptemberTask"];
            [resultDict setObject:[NSNumber numberWithBool:false] forKey:@"IsOctoberTask"];
            [resultDict setObject:[NSNumber numberWithBool:false] forKey:@"IsNovemberTask"];
            [resultDict setObject:[NSNumber numberWithBool:false] forKey:@"IsDecemberTask"];
            
            int amountTypeValue=0;
            if ([amountTypeArr indexOfObject:amountTypeButton.accessibilityHint] == 4) {
                amountTypeValue = 0;
            }else{
                amountTypeValue =(int)[amountTypeArr indexOfObject:amountTypeButton.accessibilityHint]+1;
            }
//            [resultDict setObject:[NSNumber numberWithInt:amountTypeValue] forKey:@"VitaminAmountType"];
            [resultDict setObject:[NSNumber numberWithInt:amountTypeValue] forKey:@"VitaminAmountTypeId"];

            if (_isFromEdit && _userVitaminId>0) {
                [resultDict setObject:[NSNumber numberWithInt:_userVitaminId] forKey:@"UserVitaminId"];
            }
            [mainDict setObject:resultDict forKey:@"Model"];
        }else{
            NSMutableDictionary *dict = [NSMutableDictionary new];
            [dict setObject:[NSNumber numberWithBool:0] forKey:@"January"];
            [dict setObject:[NSNumber numberWithBool:0] forKey:@"February"];
            [dict setObject:[NSNumber numberWithBool:0] forKey:@"March"];
            [dict setObject:[NSNumber numberWithBool:0] forKey:@"April"];
            [dict setObject:[NSNumber numberWithBool:0] forKey:@"May"];
            [dict setObject:[NSNumber numberWithBool:0] forKey:@"June"];
            [dict setObject:[NSNumber numberWithBool:0] forKey:@"July"];
            [dict setObject:[NSNumber numberWithBool:0] forKey:@"August"];
            [dict setObject:[NSNumber numberWithBool:0] forKey:@"September"];
            [dict setObject:[NSNumber numberWithBool:0] forKey:@"October"];
            [dict setObject:[NSNumber numberWithBool:0] forKey:@"November"];
            [dict setObject:[NSNumber numberWithBool:0] forKey:@"December"];
            
            [dict setObject:[NSNumber numberWithBool:false] forKey:@"IsSundayTask"];
            [dict setObject:[NSNumber numberWithBool:false] forKey:@"IsMondayTask"];
            [dict setObject:[NSNumber numberWithBool:false] forKey:@"IsTuesdayTask"];
            [dict setObject:[NSNumber numberWithBool:false] forKey:@"IsWednesdayTask"];
            [dict setObject:[NSNumber numberWithBool:false] forKey:@"IsThursdayTask"];
            [dict setObject:[NSNumber numberWithBool:false] forKey:@"IsFridayTask"];
            [dict setObject:[NSNumber numberWithBool:false] forKey:@"IsSaturdayTask"];

            [dict setObject:[NSNumber numberWithBool:false] forKey:@"IsJanuaryTask"];
            [dict setObject:[NSNumber numberWithBool:false] forKey:@"IsFebruaryTask"];
            [dict setObject:[NSNumber numberWithBool:false] forKey:@"IsMarchTask"];
            [dict setObject:[NSNumber numberWithBool:false] forKey:@"IsAprilTask"];
            [dict setObject:[NSNumber numberWithBool:false] forKey:@"IsMayTask"];
            [dict setObject:[NSNumber numberWithBool:false] forKey:@"IsJuneTask"];
            [dict setObject:[NSNumber numberWithBool:false] forKey:@"IsJulyTask"];
            [dict setObject:[NSNumber numberWithBool:false] forKey:@"IsAugustTask"];
            [dict setObject:[NSNumber numberWithBool:false] forKey:@"IsSeptemberTask"];
            [dict setObject:[NSNumber numberWithBool:false] forKey:@"IsOctoberTask"];
            [dict setObject:[NSNumber numberWithBool:false] forKey:@"IsNovemberTask"];
            [dict setObject:[NSNumber numberWithBool:false] forKey:@"IsDecemberTask"];
            
            [dict setObject:[NSNumber numberWithBool:0] forKey:@"Email"];
            [dict setObject:[NSNumber numberWithBool:0] forKey:@"ReminderEmail"];
            [dict setObject:[NSNumber numberWithBool:0] forKey:@"PushNotification"];
            
            //[dict setObject:[NSNumber numberWithInt:0] forKey:@"ReminderFrequencyId"];
            
            [dict setObject:[NSNumber numberWithInt:0] forKey:@"MonthReminder"];
            [dict setObject:[NSNumber numberWithInt:0] forKey:@"ReminderAt1"];
            [dict setObject:[NSNumber numberWithInt:0] forKey:@"ReminderAt2"];
            [dict setObject:[NSNumber numberWithInt:0] forKey:@"ReminderOption"];
            [dict setObject:[NSNumber numberWithBool:false] forKey:@"ReminderPushNotify"];
            
            [dict setObject:[NSNumber numberWithBool:0] forKey:@"Friday"];
            [dict setObject:[NSNumber numberWithBool:0] forKey:@"Monday"];
            [dict setObject:[NSNumber numberWithBool:0] forKey:@"Saturday"];
            [dict setObject:[NSNumber numberWithBool:0] forKey:@"Sunday"];
            [dict setObject:[NSNumber numberWithBool:0] forKey:@"Thursday"];
            [dict setObject:[NSNumber numberWithBool:0] forKey:@"Tuesday"];
            [dict setObject:[NSNumber numberWithBool:0] forKey:@"Wednesday"];
            
            [dict setObject:dateStr forKey:@"CreatedAtString"];
            [dict setObject:dateStr forKey:@"UpdatedAtString"];
            [dict setObject:[defaults objectForKey:@"UserID"] forKey:@"UserId"];
            [dict setObject:vitaminNameTextField.text forKey:@"VitaminName"];
            [dict setObject:[NSNumber numberWithInt:[tabletPerTimeTextField.text intValue]] forKey:@"TabletPerTime"];
            
            [dict setObject:[NSNumber numberWithInt:[timesPerDayButton.titleLabel.text intValue]] forKey:@"DailyAmount"];
            [dict setObject:[NSNumber numberWithInt:1] forKey:@"TaskFrequencyTypeId"];
            int amountTypeValue=0;
            if ([amountTypeArr indexOfObject:amountTypeButton.accessibilityHint] == 4) {
                amountTypeValue = 0;
            }else{
                amountTypeValue =(int)[amountTypeArr indexOfObject:amountTypeButton.accessibilityHint]+1;
            }
//            [dict setObject:[NSNumber numberWithInt:amountTypeValue] forKey:@"VitaminAmountType"];
            [dict setObject:[NSNumber numberWithInt:amountTypeValue] forKey:@"VitaminAmountTypeId"];

            if (_isFromEdit && _userVitaminId>0) {
                [dict setObject:[NSNumber numberWithInt:_userVitaminId] forKey:@"UserVitaminId"];
            }
            [mainDict setObject:dict forKey:@"Model"];
        }
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"AddUpdateUserVitamin" append:@""forAction:@"POST"];
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
                                                                         
                                                                         if (self->reminderSwitch.isOn && [[self->resultDict objectForKey:@"PushNotification"]boolValue]) {
                                                                             if(![Utility isEmptyCheck:[responseDict objectForKey:@"UserVitaminId"]]){
                                                                                 [self->resultDict setObject:[responseDict objectForKey:@"UserVitaminId"] forKey:@"UserVitaminId"];
                                                                                 [self generateNotification:[self->resultDict mutableCopy]];
                                                                             }
//                                                                             [SetReminderViewController setOldLocalNotificationFromDictionary:self->resultDict ExtraData:[NSMutableDictionary new] FromController:@"Vitamin" Title:[self->resultDict objectForKey:@"VitaminName"] Type:@"Vitamin" Id:[[resultDict objectForKey:@"UserVitaminId"]intValue]];
                                                                         }
                                                                         if ([self->addVitaminDelegate respondsToSelector:@selector(addDataReload)]) {
                                                                             [self->addVitaminDelegate addDataReload];
                                                                         }                                                                         [self.navigationController popViewControllerAnimated:YES];
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
-(void)webSerViceCall_GetUserVitamin{
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
        //        [mainDict setObject:[defaults objectForKey:@"UserID"] forKey:@"UserID"];
        [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[NSNumber numberWithInt:_userVitaminId] forKey:@"UserVitaminId"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetUserVitamin" append:@""forAction:@"POST"];
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
                                                                         if (![Utility isEmptyCheck:[responseDict objectForKey:@"Model"]]) {
                                                                             [self setUpViewForEdit:[responseDict objectForKey:@"Model"]];
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
-(void)webSerViceCall_GetUserVitaminGroups{
    if (Utility.reachable) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (self->contentView) {
//                [self->contentView removeFromSuperview];
//            }
//            self->contentView = [Utility activityIndicatorView:self];
//        });
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
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetUserVitaminGroups" append:@""forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
//                                                                 if (self->contentView) {
//                                                                     [self->contentView removeFromSuperview];
//                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"SuccessFlag"]boolValue]) {
                                                                         if (![Utility isEmptyCheck:[responseDict objectForKey:@"List"]]) {
                                                                             self->grouplistArray = [responseDict objectForKey:@"List"];
                                                                         }
                                                                         [self prepareView];
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
-(void)webSerViceCall_DeleteUserVitamin{
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
        //        [mainDict setObject:[defaults objectForKey:@"UserID"] forKey:@"UserID"];
        [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[NSNumber numberWithInt:_userVitaminId] forKey:@"UserVitaminId"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"DeleteUserVitamin" append:@""forAction:@"POST"];
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
                                                                         
                                                                         NSArray *requests = [[UIApplication sharedApplication] scheduledLocalNotifications];
                                                                         for (UILocalNotification *req in requests) {
                                                                             NSString *pushTo = [req.userInfo objectForKey:@"pushTo"];
                                                                             int idValue = [[req.userInfo objectForKey:@"ID"]intValue];
                                                                             if ([pushTo caseInsensitiveCompare:@"Vitamin"] == NSOrderedSame && (idValue == self->_userVitaminId)) {
                                                                                 NSLog(@"Cancel------------%@",req.userInfo);
                                                                                 [[UIApplication sharedApplication] cancelLocalNotification:req];
                                                                             }
                                                                         }
                                                                         if ([self->addVitaminDelegate respondsToSelector:@selector(addDataReload)]) {
                                                                             [self->addVitaminDelegate addDataReload];
                                                                         }
                                                                         [self.navigationController popViewControllerAnimated:YES];
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

#pragma mark - Private Function
-(void)prepareView{
    resultDict = [NSMutableDictionary new];
    saveButton.layer.cornerRadius=8;
    saveButton.layer.masksToBounds=YES;
    
    deleteButton.layer.cornerRadius=8;
    deleteButton.layer.masksToBounds = YES;
    
    reminderTimeArray = [[NSMutableArray alloc]init];
    dayArray = [[NSArray alloc]init];
    nameArray = [[NSMutableArray alloc] init];
    amountTypeArr = @[@"tablets",@"scoops",@"grams",@"ml",@"other"];
    
    if (_isFromEdit) {
//        editLabelView.hidden = false;
//         deleteButton.hidden = false;
        [self webSerViceCall_GetUserVitamin];
    }else{
//        editLabelView.hidden = true;
//        deleteButton.hidden = true;
        [amountTypeButton setTitle:[[amountTypeArr objectAtIndex:0] capitalizedString] forState:UIControlStateNormal];
        amountTypeButton.accessibilityHint = [amountTypeArr objectAtIndex:0];
    }
    [reminderTimeArray addObject:@"12 am"];
    for (int i = 1; i < 12; i++) {
        [reminderTimeArray addObject:[NSString stringWithFormat:@"%d am",i]];
    }
    [reminderTimeArray addObject:@"12 pm"];
    for (int i = 1; i < 12; i++) {
        [reminderTimeArray addObject:[NSString stringWithFormat:@"%d pm",i]];
    }
    NSDateFormatter *newDateformatter = [[NSDateFormatter alloc]init];
    dayArray = [newDateformatter weekdaySymbols];
    for (UIButton  *daysButton in daysButtons) {
        daysButton.layer.cornerRadius = daysButton.frame.size.height/2;
        [self changeButtonBackground:daysButton selected:false];
    }
    toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)]; //toolbar is uitoolbar object
    toolBar.barStyle = UIBarStyleBlackOpaque;
    toolBar.translucent = YES;
    UIBarButtonItem *btnDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(btnClickedDone:)];
    [toolBar setItems:[NSArray arrayWithObject:btnDone]];
    [self registerForKeyboardNotifications];

    
}
-(void)setUpViewForEdit:(NSDictionary*)modelDict{
    NSLog(@"%@",[modelDict objectForKey:@"VitaminName"]);
    if (![Utility isEmptyCheck:[modelDict objectForKey:@"VitaminName"]]) {
        vitaminNameTextField.text = [modelDict objectForKey:@"VitaminName"];
    }
    if (![Utility isEmptyCheck:[modelDict objectForKey:@"DailyAmount"]]) {
        [timesPerDayButton setTitle:[@"" stringByAppendingFormat:@"%@",[modelDict objectForKey:@"DailyAmount"]] forState:UIControlStateNormal];
        timesPerDayButton.accessibilityHint = [@"" stringByAppendingFormat:@"%@",[modelDict objectForKey:@"DailyAmount"]];
        selectedIndex = [timesPerDayButton.accessibilityHint intValue]-1;

    }
    if (![Utility isEmptyCheck:[modelDict objectForKey:@"VitaminAmountTypeId"]] && [[modelDict objectForKey:@"VitaminAmountTypeId"]intValue]>0) {
        int index = [[modelDict objectForKey:@"VitaminAmountTypeId"]intValue];
        amountIndex = index;
        [amountTypeButton setTitle:[amountTypeArr[index] capitalizedString] forState:UIControlStateNormal];
        amountTypeButton.accessibilityHint = amountTypeArr[index];
    }
    
    [self updateAmountTypeTitle];
    
    if ((![Utility isEmptyCheck:[modelDict objectForKey:@"ReminderFrequencyId"]] && [[modelDict objectForKey:@"ReminderFrequencyId"]intValue]>0) || (![Utility isEmptyCheck:[modelDict objectForKey:@"ReminderVitaminId"]] && [[modelDict objectForKey:@"ReminderVitaminId"]intValue]>0)) {
            reminderSwitch.on=YES;
        }else{
            reminderSwitch.on = NO;
        }
        if (![Utility isEmptyCheck:resultDict]) {
            [resultDict removeAllObjects];
        }
        resultDict = [modelDict mutableCopy];
    
    if (_isFromNotification) {
        
        if((![Utility isEmptyCheck:[resultDict objectForKey:@"ReminderFrequencyId"]] && [[resultDict objectForKey:@"ReminderFrequencyId"]intValue]>0) || (![Utility isEmptyCheck:[resultDict objectForKey:@"ReminderVitaminId"]] && [[resultDict objectForKey:@"ReminderVitaminId"]intValue]>0)){
            [self reminderValueChanged:nil];
        }
    }
    
    if (![Utility isEmptyCheck:[modelDict objectForKey:@"ReminderAt1"]]) {
        [reminderTimeButton setTitle:[@""stringByAppendingFormat:@"%@",[modelDict objectForKey:@"ReminderAt1"]]forState:UIControlStateNormal];
    }
    if (![Utility isEmptyCheck:[modelDict objectForKey:@"ReminderAt2"]]) {
        [reminderAndTimeButton setTitle:[@"" stringByAppendingFormat:@"%@",[modelDict objectForKey:@"ReminderAt2"]] forState:UIControlStateNormal];
    }
    if (![Utility isEmptyCheck:[modelDict objectForKey:@"ReminderFrequencyId"]]) {
        [self generateNotification:[modelDict mutableCopy]];
    }
    if (![Utility isEmptyCheck:[modelDict objectForKey:@"TabletPerTime"]]) {
        tabletPerTimeTextField.text = [@"" stringByAppendingFormat:@"%@",[modelDict objectForKey:@"TabletPerTime"]];
    }
}
-(void)changeButtonBackground:(UIButton *)button selected:(BOOL)selected{
    if (selected) {
        button.layer.borderColor =[Utility colorWithHexString:@"E425A0"].CGColor;
        button.layer.borderWidth=1;
        [button setBackgroundColor:squadMainColor];
    } else {
        button.layer.borderColor =[Utility colorWithHexString:@"585858"].CGColor;
        button.layer.borderWidth=1;
        [button setBackgroundColor:[UIColor whiteColor]];
    }
}
-(BOOL)sentVitaminNotificationFromDictionary:(NSMutableDictionary*)notificationDict title:(NSString*)title seqNO:(int)seqNo twiceBetSq:(int)twiceBetSq{
    NSInteger remHour = 0;
    NSInteger remHour1 = ![Utility isEmptyCheck:[notificationDict objectForKey:@"ReminderAt1"]] ? [[notificationDict objectForKey:@"ReminderAt1"] integerValue] : 12;
    NSInteger remHour2 = ![Utility isEmptyCheck:[notificationDict objectForKey:@"ReminderAt2"]] ? [[notificationDict objectForKey:@"ReminderAt2"] integerValue] : 12;
    NSInteger remMin = 0;
    
    switch ([[notificationDict objectForKey:@"FrequencyId"] intValue]) {
        case 0:
        case 1:
            //at
            remHour = remHour1;
            break;
            
        case 2:
            //twice between
            if (twiceBetSq == 0) {
                remHour = remHour1;
            } else {
                remHour = remHour2;
            }
            break;
        default:
            break;
    }
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [calendar setTimeZone: [NSTimeZone systemTimeZone]];
    NSDateComponents *components= [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitWeekday | NSCalendarUnitWeekdayOrdinal | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute) fromDate: [NSDate date]];
    NSCalendarUnit calUnit = NSCalendarUnitDay;
    switch ([[notificationDict objectForKey:@"Weekly"] intValue]) {
            
        case 1:
            //daily
            [components setHour: remHour];
            [components setMinute: remMin];
            [components setSecond: 00];
            calUnit = NSCalendarUnitDay;
            break;
            
        case 2:
            //twice daily
        {
            NSInteger remAt = 0;
            if (seqNo == 0) {
                if (![Utility isEmptyCheck:[notificationDict objectForKey:@"ReminderAt1"]]) {
                    remAt = [[notificationDict objectForKey:@"ReminderAt1"] integerValue];
                }
            } else {
                if (![Utility isEmptyCheck:[notificationDict objectForKey:@"ReminderAt2"]]) {
                    remAt = [[notificationDict objectForKey:@"ReminderAt2"] integerValue];
                }
            }
            
            [components setHour: remAt];
            [components setMinute: 00];
            [components setSecond: 00];
            calUnit = NSCalendarUnitDay;
        }
            break;
        case 3:
            //weekly
        {
            NSInteger todayComp = [components weekday]-1;
            NSInteger daysLeft = [[nameArray objectAtIndex:seqNo] integerValue]- todayComp;//- todayComp;
            NSDate *toDate = [[NSDate date] dateByAddingTimeInterval:daysLeft*24*3600];
            NSDateComponents *toComp = [calendar components:(NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear) fromDate:toDate];
            
            [components setYear:[toComp year]];
            [components setMonth:[toComp month]];
            [components setDay:[toComp day]];
            [components setWeekday:![Utility isEmptyCheck:nameArray] ? [[nameArray objectAtIndex:seqNo] integerValue] : 0];
            [components setHour: remHour];
            [components setMinute: remMin];
            [components setSecond: 00];
            calUnit = NSCalendarUnitWeekOfYear;
        }
            break;
        default:
            break;
    }
    NSDate *dateToFire = [calendar dateFromComponents:components];
    NSLog(@"fire date:\n\n%@", dateToFire);
    int eventID1 = 0;
    NSString *fromController =@"Vitamin";
    NSString *alertBody = @"Vitamin reminder";
    
    NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:fromController, @"pushTo", @"reminder", @"remType", [NSNumber numberWithInt:eventID1], @"ID",nil];
    //extraDict, @"extraData",
    
    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = dateToFire;
    localNotification.alertTitle = title;//alertBody;
    localNotification.alertBody = alertBody;//title;
    localNotification.alertAction = @"Check Now";
    [localNotification setTimeZone: [NSTimeZone defaultTimeZone]];
    [localNotification setRepeatInterval: calUnit];
    localNotification.soundName = @"Notification.caf";
    [localNotification setUserInfo:userInfo];
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    
    NSLog(@"localNoti --> \n%@",localNotification);
    
    return YES;
}
-(IBAction)btnClickedDone:(id)sender{
    [self.view endEditing:YES];
    if ([dailyAmountTextField.text intValue] == 1) {
        reminderTimeButton.hidden = false;
        reminderAndTimeButton.hidden = true;
    }else if ([dailyAmountTextField.text intValue] >= 2){
        reminderTimeButton.hidden= false;
        reminderAndTimeButton.hidden = false;
    }
}

-(BOOL)validationCheck {
    BOOL isValid = NO;
    NSString *dailyAmountStr = timesPerDayButton.titleLabel.text;
    NSString *vitaminNameStr = vitaminNameTextField.text;
    NSString *vitaminTabletPerTime = tabletPerTimeTextField.text;
    if ([Utility isEmptyCheck:vitaminNameStr]) {
        [Utility msg:@"Please enter Vitamin Name." title:@"Oops!" controller:self haveToPop:NO];
        return isValid;
    }else if ([Utility isEmptyCheck:dailyAmountStr]) {
              [Utility msg:@"Please enter Times Per Day of Vitamin." title:@"Oops!" controller:self haveToPop:NO];
              return isValid;
    }else if ([Utility isEmptyCheck:vitaminTabletPerTime]){
             [Utility msg:@"Please enter Amount" title:@"Oops!" controller:self haveToPop:NO];
            return isValid;
    }
//    else if(nameArray.count<0){
//        [Utility msg:@"Please select day frequency." title:@"Oops!" controller:self haveToPop:NO];
//        return isValid;
//    }
    return YES;
}
//-(void)vitaminReminder{
//        NSCalendar *calendar = [NSCalendar currentCalendar];
//        [calendar setTimeZone:[NSTimeZone systemTimeZone]];
//        int dailyAmountOfVitamin =[dailyAmountTextField.text intValue];
//        if (dailyAmountOfVitamin >=2) {
//            dailyAmountOfVitamin = 2;
//        }else{
//            dailyAmountOfVitamin = 1;
//        }
//        NSLog(@"=========%@",[nameArray sortedArrayUsingSelector: @selector(compare:)]);
//        NSArray *arr = [nameArray sortedArrayUsingSelector: @selector(compare:)];
//        resultDict = [NSMutableDictionary new];
//        [resultDict setObject:reminderTimeButton.titleLabel.text forKey:@"ReminderAt1"];
//        [resultDict setObject:reminderAndTimeButton.titleLabel.text forKey:@"ReminderAt2"];
//        [resultDict setObject:[NSNumber numberWithInt:dailyAmountOfVitamin] forKey:@"FrequencyId"];
//        [resultDict setObject:[NSNumber numberWithInt:3] forKey:@"Weekly"];
//        if (![Utility isEmptyCheck:resultDict]) {
//            if (![Utility isEmptyCheck:arr]) {
//                for (int i = 0; i < arr.count; i++) {
//                    for (int t = 0; t < dailyAmountOfVitamin; t++) {
//                        [self sentVitaminNotificationFromDictionary:resultDict title:vitaminNameTextField.text seqNO:i twiceBetSq:t];
//                    }
//                }
//            }
//        }
//}

-(void)generateNotification:(NSMutableDictionary*)modelDict{
    NSArray *requests = [[UIApplication sharedApplication] scheduledLocalNotifications];
    for (UILocalNotification *req in requests) {
        NSString *pushTo = [req.userInfo objectForKey:@"pushTo"];
        int idValue = [[req.userInfo objectForKey:@"ID"]intValue];
        if (![Utility isEmptyCheck:[modelDict objectForKey:@"ReminderVitaminId"]]) {
            if ([pushTo caseInsensitiveCompare:@"Vitamin"] == NSOrderedSame && (idValue == [[modelDict objectForKey:@"ReminderVitaminId"]intValue])) {
                [[UIApplication sharedApplication] cancelLocalNotification:req];
            }
        }else{
            if ([pushTo caseInsensitiveCompare:@"Vitamin"] == NSOrderedSame && (idValue == [[modelDict objectForKey:@"UserVitaminId"]intValue])) {
                [[UIApplication sharedApplication] cancelLocalNotification:req];
            }
        }
    }
    NSMutableDictionary *extraData = [[NSMutableDictionary alloc] init];
    if (![Utility isEmptyCheck:[modelDict objectForKey:@"ReminderVitaminId"]]) {
        [extraData setObject:[modelDict objectForKey:@"ReminderVitaminId"] forKey:@"Id"];
    }else{
        [extraData setObject:[modelDict objectForKey:@"UserVitaminId"] forKey:@"Id"];

    }
    NSString * result=@"";
    if (![Utility isEmptyCheck:[modelDict valueForKey:@"AttachedVitamins"]]) {
        result = [[modelDict valueForKey:@"AttachedVitamins"] componentsJoinedByString:@","];
    }else{
        if (![Utility isEmptyCheck:vitaminStr]) {
            
            result = [@"" stringByAppendingFormat:@"%@,%@",vitaminStr,[modelDict objectForKey:@"VitaminName"]];
        }else{
            NSArray *filteredArr;
            if (![Utility isEmptyCheck:[modelDict objectForKey:@"ReminderVitaminId"]]) {
                NSLog(@"=====%@",[modelDict objectForKey:@"ReminderVitaminId"]);
                filteredArr = [grouplistArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(UserVitaminId == %@)", [modelDict objectForKey:@"ReminderVitaminId"]]];
                NSLog(@"=====%@",grouplistArray);
            }else{
                filteredArr = [grouplistArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(UserVitaminId == %@)", [modelDict objectForKey:@"UserVitaminId"]]];

            }
            if (filteredArr.count>0) {
                NSDictionary *dict = [filteredArr objectAtIndex:0];
                if ([Utility isEmptyCheck:[dict objectForKey:@"AttachedVitamins"]]) {
                    result = [@"" stringByAppendingFormat:@"%@",[dict objectForKey:@"VitaminName"]];
                    
                }else{
                    result = [[dict valueForKey:@"AttachedVitamins"] componentsJoinedByString:@","];
                }
            }else{
                result = [@"" stringByAppendingFormat:@"%@",[modelDict objectForKey:@"VitaminName"]];
                
            }
        }
       
    }

//    [SetReminderViewController setOldLocalNotificationFromDictionary:modelDict ExtraData:extraData FromController:@"Vitamin" Title:result Type:@"Vitamin" Id:[[modelDict objectForKey:@"UserVitaminId"]intValue]];//[modelDict objectForKey:@"VitaminName"]
}
-(void)updateAmountTypeTitle{
    
    NSLog(@"TPD:%@ and AmountType:%@",timesPerDayButton.titleLabel.text,amountTypeButton.accessibilityHint);
    
    if([timesPerDayButton.accessibilityHint intValue]>0 && amountTypeButton.accessibilityHint.length>0){
        [amountTypeButton setTitle:[@"" stringByAppendingFormat:@"%@ x %@",[amountTypeButton.accessibilityHint capitalizedString],timesPerDayButton.accessibilityHint] forState:UIControlStateNormal];
    }
}

-(void)reminderAlert{
    NSString *reminderType = @"";
    if (_isFromNotification) {
        reminderType =@"CHANGE REMINDER";
    }else{
        reminderType = @"NEW REMINDER";
    }
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"REMINDER"
                                          message:@""
                                          preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *newReminderAction = [UIAlertAction
                               actionWithTitle:reminderType
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   SetReminderViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SetReminder"];
                                   if ([self->resultDict objectForKey:@"FrequencyId"] != nil)//FrequencyId
                                       controller.defaultSettingsDict = self->resultDict;
                                   controller.reminderDelegate = self;
                                   controller.fromController=@"Vitamin";
                                   controller.view.backgroundColor = [UIColor clearColor];
                                   controller.modalPresentationStyle = UIModalPresentationCustom;
                                   [self presentViewController:controller animated:YES completion:nil];
                               }];
    UIAlertAction *gpReminderAction = [UIAlertAction
                                   actionWithTitle:@"GROUP REMINDER"
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {
                                       self->gpReminderView.hidden = false;
                                       [self->gpReminderDetailsTable reloadData];
                                   }];
    [alertController addAction:newReminderAction];
    [alertController addAction:gpReminderAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
#pragma mark  - DropDown Delegate
-(void) dropdownSelected:(NSString *)selectedValue sender:(UIButton *)sender type:(NSString *)type{
    if ([type isEqualToString:@"TimesPerDay"]) {
        timesPerDayButton.accessibilityHint = selectedValue;
        selectedIndex =[selectedValue intValue]-1;
        [timesPerDayButton setTitle:selectedValue forState:UIControlStateNormal];
    }else if ([type isEqualToString:@"AmountType"]){
        amountIndex = (int)[amountTypeArr indexOfObject:selectedValue];
        amountTypeButton.accessibilityHint = selectedValue;
        [amountTypeButton setTitle:selectedValue forState:UIControlStateNormal];
    }
    [self updateAmountTypeTitle];
}
#pragma mark - End



#pragma mark - KeyboardNotifications -
// Call this method somewhere in your view controller setup code.
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    NSInteger orientation=[UIDevice currentDevice].orientation;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) {
        //ios7
        if (UIDeviceOrientationIsLandscape(orientation))
        {
            kbSize=CGSizeMake(kbSize.height, kbSize.width);
        }else if (UIDeviceOrientationIsPortrait(orientation)){
            kbSize=CGSizeMake(kbSize.width, kbSize.height);
        }
    }
    else {
        //iOS 8 specific code here
        if (UIDeviceOrientationIsLandscape(orientation))
        {
            kbSize=CGSizeMake(kbSize.width, kbSize.height);
        }else if (UIDeviceOrientationIsPortrait(orientation)){
            kbSize=CGSizeMake(kbSize.width, kbSize.height);
        }
    }
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height-130, 0.0);
    mainScroll.contentInset = contentInsets;
    mainScroll.scrollIndicatorInsets = contentInsets;
    
    if (activeTextField !=nil) {
        CGRect aRect = mainScroll.frame;
        CGRect frame = [mainScroll convertRect:activeTextField.frame fromView:activeTextField.superview];
        aRect.size.height -= kbSize.height;
        if (!CGRectContainsPoint(aRect,frame.origin) ) {
            [mainScroll scrollRectToVisible:frame animated:YES];
        }
    }else if (activeTextView !=nil) {
        CGRect aRect = mainScroll.frame;
        CGRect frame = [mainScroll convertRect:activeTextView.frame fromView:activeTextView.superview];
        aRect.size.height -= kbSize.height;
        if (!CGRectContainsPoint(aRect,frame.origin) ) {
            [mainScroll scrollRectToVisible:frame animated:YES];
        }
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    mainScroll.contentInset = contentInsets;
    mainScroll.scrollIndicatorInsets = contentInsets;
    
}
#pragma mark - End -

#pragma mark - textField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [textField setInputAccessoryView:toolBar];
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    activeTextField = textField;
    activeTextView = nil;
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    activeTextField = nil;
}
#pragma mark - End

#pragma mark - ReminderDelegate
-(void) reminderSettingsValue:(NSMutableDictionary *)reminderDict {
    NSLog(@"rem %@",reminderDict);
    if (![Utility isEmptyCheck:reminderDict] && [[reminderDict objectForKey:@"isGruopEnable"]boolValue]) {
        gpReminderView.hidden=true;
        [reminderDict setObject:[reminderDict objectForKey:@"UserVitaminId"] forKey:@"ReminderVitaminId"];
        if ([reminderDict objectForKey:@"UserVitaminId"]>0) {
            [reminderDict setObject:[NSNumber numberWithInt:0] forKey:@"UserVitaminId"];
        }
        [reminderDict removeObjectForKey:@"isGruopEnable"];
        
        resultDict = reminderDict;
        [self dismissViewControllerAnimated:NO completion:^{
            if ([self validationCheck]) {
                [self webSerViceCall_AddUpdateUserVitamin];
            }
        }];
    }else{
        resultDict = reminderDict;
    }
//    if ((![Utility isEmptyCheck:[reminderDict objectForKey:@"ReminderVitaminId"]] && [[reminderDict objectForKey:@"ReminderVitaminId"]intValue]>0)) {
//        gpReminderView.hidden=true;
//        [reminderDict setObject:[reminderDict objectForKey:@"UserVitaminId"] forKey:@"ReminderVitaminId"];
//        if ([reminderDict objectForKey:@"UserVitaminId"]>0) {
//            [reminderDict setObject:[NSNumber numberWithInt:0] forKey:@"UserVitaminId"];
//        }
//        resultDict = reminderDict;
//        [self dismissViewControllerAnimated:NO completion:^{
//            if ([self validationCheck]) {
//                [self webSerViceCall_AddUpdateUserVitamin];
//            }
//        }];
//    }else{
//       resultDict = reminderDict;
//    }
}
-(void) cancelReminder {
    if ([resultDict objectForKey:@"FrequencyId"] != nil) {
    } else {
        [reminderSwitch setOn:NO];
        [resultDict removeObjectForKey:@"FrequencyId"];
    }
}
#pragma mark - End

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return grouplistArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *CellIdentifier =@"AddVitaminTableViewCell";
    AddVitaminTableViewCell *cell = (AddVitaminTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // Configure the cell...
    if (cell == nil) {
        cell = [[AddVitaminTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if (![Utility isEmptyCheck:[grouplistArray objectAtIndex:indexPath.row]]) {
        NSDictionary *gpdict =[grouplistArray objectAtIndex:indexPath.row];
        if ([Utility isEmptyCheck:[gpdict valueForKey:@"AttachedVitamins"]]) {
            if (![Utility isEmptyCheck:[gpdict objectForKey:@"VitaminName"]]) {
                cell.gpVitaminLabel.text = [gpdict objectForKey:@"VitaminName"];
            }
        }else{
                cell.gpVitaminLabel.text = [[gpdict valueForKey:@"AttachedVitamins"] componentsJoinedByString:@","];
        }
      
        if (![Utility isEmptyCheck:[gpdict objectForKey:@"RemindersAttached"]]) {
            if ([[gpdict objectForKey:@"RemindersAttached"]boolValue]) {
                cell.gpVitaminLabel.text = [@"" stringByAppendingFormat:@"%@ (Grouped)",cell.gpVitaminLabel.text];
            }else{
                cell.gpVitaminLabel.text = [@"" stringByAppendingFormat:@"%@",cell.gpVitaminLabel.text];
            }
        }else{
            cell.gpVitaminLabel.text = [@"" stringByAppendingFormat:@"%@",cell.gpVitaminLabel.text];
        }
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (![Utility isEmptyCheck:[grouplistArray objectAtIndex:indexPath.row]]) {
        NSDictionary *gpDict = [grouplistArray objectAtIndex:indexPath.row];
        SetReminderViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SetReminder"];
        if ([gpDict objectForKey:@"FrequencyId"] != nil)//FrequencyId
            controller.defaultSettingsDict = gpDict;
        if ([Utility isEmptyCheck:[gpDict valueForKey:@"AttachedVitamins"]]) {
            if (![Utility isEmptyCheck:[gpDict objectForKey:@"VitaminName"]]) {
                vitaminStr = [gpDict objectForKey:@"VitaminName"];
            }
        }else{
            vitaminStr = [[gpDict valueForKey:@"AttachedVitamins"] componentsJoinedByString:@","];
        }
        controller.reminderDelegate = self;
        controller.fromController=@"Vitamin";
        controller.fromAddVitaminGp=true;
        controller.view.backgroundColor = [UIColor clearColor];
        controller.modalPresentationStyle = UIModalPresentationCustom;
        [self presentViewController:controller animated:YES completion:nil];
    }
}

@end
