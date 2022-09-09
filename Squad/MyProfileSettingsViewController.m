//
//  MyProfileSettingsViewController.m
//  Squad
//
//  Created by AQB Solutions-Mac Mini 2 on 22/03/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import "MyProfileSettingsViewController.h"
#import "MyProfileViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ProfileTableViewCell.h"
#import "NotificationSettingTableViewCell.h"
#import "DisplayImageViewController.h"
#import "SignupWithEmailViewController.h"


@interface MyProfileSettingsViewController ()
{
    IBOutlet UILabel *memberActiveLabel;
    IBOutlet UIImageView *headerBg;
    IBOutlet UILabel *profileNameLabel;
    IBOutlet UITextField *FirstNameTextField;
    IBOutlet UITextField *LastNameTextField;
    
    IBOutlet UITextField *phoneNumberTextField;
    IBOutlet UITextField *dateofBirthTextField;
    IBOutlet UITextField *passwordTextField;
    IBOutlet UITextField *confirmPasswordTextField;
    IBOutlet UIButton *timeZoneButton;
    
    
    IBOutlet UISwitch *receiveWeeklyMailSwitch;
    IBOutlet UIButton *editButton;
    IBOutlet UIButton *saveButton;
    IBOutlet UIButton *cancelButton;

    IBOutlet UIButton *saveNotificationButton;
    
    UIView *contentView;
    NSMutableDictionary *profileDetailsDict;
    IBOutlet UIImageView *profileImage;
    UITextField *activeTextField;
    IBOutlet UIScrollView *mainScroll;
    UITextView *activeTextView;
    NSMutableArray *tableDataArray;
    NSMutableArray *unitPreferenceArray;
    UIImage *galaryimage;
    
    IBOutlet UIButton *displayImageButton;
    
    IBOutlet UIButton *editImage;
    IBOutlet UITableView *notificationSettingTableView;
    IBOutlet NSLayoutConstraint *notificationSettingTableHeightConstraint;
    IBOutlet UIButton *squadCity;
    IBOutlet UIButton *squadSuburb;
    IBOutlet UISwitch *applyRoundingSwitch;
    
    IBOutlet UIView *userPreferenceContainerView;
    IBOutlet UISwitch *unitPreferenceSwitch;
    IBOutlet UILabel *unitPreferenceSubtitle;
    
    IBOutlet UIButton *cancelSquadSubscription;
    IBOutlet UILabel *cancelSubscrText;
    
    __weak IBOutlet UILabel *updateCardLabel;
    
    __weak IBOutlet UIButton *updateCardButton;
    
    NSMutableArray *notificationArray;
    int apiCallCount;
    NSMutableArray *timeZoneArray;
    int selectedTimeZoneIndex;
    NSDictionary *unitPreference;
    NSString *unitpreferenceValue;
    UISwitch *preferenceSwitch;
    UILabel *preferenceValueLabel;
    NSString *optionUnitValue;
    NSDictionary *profileDataDict;
    NSDate *selectedDate;
    NSString *phoneNo;
    int signupVia;
    IBOutlet UIButton *dobButton;
    IBOutlet UISwitch *dailyQuoteSwitch;
    IBOutlet UISwitch *visionBoardPopUpSwitch;
    
}
@end

@implementation MyProfileSettingsViewController

#pragma mark - IBAction
- (IBAction)logoButtonPressed:(UIButton *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (IBAction)cancelButtonSelect:(id)sender{
    [self setUpView];
}
- (IBAction)profileImageButtonSelect:(id)sender{
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appdelegate.autoRotate=YES;
    DisplayImageViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"DisplayImage"];
    controller.modalPresentationStyle = UIModalPresentationCustom;
    controller.image = galaryimage;
    [self presentViewController:controller animated:YES completion:nil];
}
- (IBAction)timeZoneButtonPressed:(UIButton *)sender {
    PopoverSettingsViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PopoverSettingsView"];

    controller.modalPresentationStyle = UIModalPresentationCustom;
    controller.tableDataArray = timeZoneArray;
    controller.sender = sender;
    controller.selectedIndex = selectedTimeZoneIndex;
    controller.delegate = self;
    [self presentViewController:controller animated:YES completion:nil];
}

- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)saveButtonPressed:(id)sender {
    [self doneButton];
    NSString *dateStr=dobButton.titleLabel.text;//dateofBirthTextField.text
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd/MM/yyyy"];
    NSDate *date = [dateFormat dateFromString:dateStr];
    if(![Utility isEmptyCheck:dateStr] && date){
        [dateFormat setTimeZone:[NSTimeZone systemTimeZone]];
        [dateFormat setDateFormat:@"yyyy-MM-dd"];
        NSString *dobString = [dateFormat stringFromDate:date];
        if (![Utility isEmptyCheck:dobString]) {
            NSDate *today = [NSDate date]; // it will give you current date
            NSComparisonResult result;
            result = [today compare:date]; // comparing two dates
            if(result==NSOrderedAscending){
                NSLog(@"today is less");
                [Utility msg:@"Date is not valid" title:@"Alert" controller:self haveToPop:NO];
                return;
            }else{
                [self saveProfileWebServiceCallWithPhoto:dobString];
            }
        }else{
            [Utility msg:@"Date is not valid" title:@"Alert" controller:self haveToPop:NO];
            return;
        }
    }else{
        [self saveProfileWebServiceCallWithPhoto:@""];
    }
    
    
}

- (IBAction)checkUncheckButtonPressed:(UIButton*)sender {
    
}

- (IBAction)editprofilebuttonPressed:(id)sender {
    
//    if([defaults boolForKey:@"IsNonSubscribedUser"]){
//        [Utility showProfileEditRestrictionAlert:self];
//        return;
//    }
    
    BOOL isFbUser = [defaults boolForKey:@"IsFbUser"];
    editImage.hidden = false;
    displayImageButton.hidden = true;
    editButton.hidden = true;
    cancelButton.hidden = false;
    saveButton.hidden = false;
    profileDetailsDict = [[NSMutableDictionary alloc]init];
    FirstNameTextField.userInteractionEnabled = true;
    LastNameTextField.userInteractionEnabled = true;
    phoneNumberTextField.userInteractionEnabled = true;
    dateofBirthTextField.userInteractionEnabled = true;
    dobButton.userInteractionEnabled = true;
    if(!isFbUser){
        passwordTextField.userInteractionEnabled = true;
        confirmPasswordTextField.userInteractionEnabled=true;
    }
    
    receiveWeeklyMailSwitch.userInteractionEnabled = true;
    timeZoneButton.enabled  =true ;
    /*NSString *phoneNumber = [profileDataDict objectForKey:@"Phone"];
    if (![Utility isEmptyCheck:phoneNumber]){
        if ([phoneNumber  isEqualToString: @"iphone"] || [phoneNumber  isEqualToString:@"android"]){
            phoneNumberTextField.enabled =false;
        }
        else{
            phoneNumberTextField.enabled =true;
        }
    }*/
    //add on
    
    applyRoundingSwitch.userInteractionEnabled=true;
    unitPreferenceSwitch.userInteractionEnabled=true;
}
- (IBAction)editProfileImageButtonPressed:(id)sender {
    //    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Alert"
    //                                                                   message:@""
    //                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertController* alert = [UIAlertController
                                alertControllerWithTitle:nil      //  Must be "nil", otherwise a blank title area will appear above our two buttons
                                message:nil
                                preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction* cameraAction = [UIAlertAction actionWithTitle:@"Take A Photo" style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {
                                                             NSLog(@"Photo is selected");
                                                             [self showCamera];
                                                         }];
    
    UIAlertAction* galleryAction = [UIAlertAction actionWithTitle:@"Browse Photo" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              NSLog(@"Gallery is selected");
                                                              [self openPhotoAlbum];
                                                          }];
    
    UIAlertAction * defaultAct = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel
                                                        handler:^(UIAlertAction * action) {
                                                            NSLog(@"Cancel is clicked");
                                                            [self closeActionsheet];
                                                        }];
    
    [alert addAction:cameraAction];
    [alert addAction:galleryAction];
    [alert addAction:defaultAct];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (IBAction)saveNotificationbuttonPressed:(id)sender {
    
    if([defaults boolForKey:@"IsNonSubscribedUser"]){
        //[Utility showProfileEditRestrictionAlert:self];
        [Utility showSubscribedAlert:self];
        return;
    }
    
    if ([Utility isEmptyCheck:notificationArray]) {
        return;
    }
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
        [mainDict setObject:[defaults valueForKey:@"UserID"] forKey:@"User_id"];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults valueForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        for (NSDictionary * dict in notificationArray) {
            [mainDict setObject:[dict valueForKey:@"Value"] forKey:[dict valueForKey:@"Key"]];
        }
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"SaveUserNotificationApiCall" append:@"" forAction:@"POST"];
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
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict]) {
                                                                         NSArray *tempArray =[responseDict valueForKey:@"EventTypeNotification"];
                                                                         if(![Utility isEmptyCheck:tempArray]){
                                                                             self->notificationArray = [[NSMutableArray alloc]initWithArray:tempArray];
                                                                         }else{
                                                                             self->notificationArray = [[NSMutableArray alloc]init];
                                                                         }
                                                                         [self->saveButton sendActionsForControlEvents:UIControlEventTouchUpInside];
                                                                         [self->notificationSettingTableView reloadData];
                                                                         
                                                                         
                                                                     }else{
                                                                         [Utility msg:@"Something is wrong.Please try later." title:@"Error !" controller:self haveToPop:NO];
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

- (IBAction)clickHere:(UIButton *)sender {
     if (signupVia == Shopify && ![defaults boolForKey:@"IsNonSubscribedUser"]){
        
        if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:CANCEL_SUBSCRIPTION_LINK]]){
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:CANCEL_SUBSCRIPTION_LINK] options:@{} completionHandler:^(BOOL success) {
                if(success){
                    NSLog(@"Opened");
                    }
            }];
        }
        
    }else{
       [Utility cancelSubscriptionAlert:self isWeb:NO];
    }
    
    
    
}
- (IBAction)receivedWeeklyMailSwitchValueChanged:(UISwitch *)sender {
}
- (IBAction)notificationSettingSwitchValueChange:(UISwitch *)sender {
    if([sender isOn]){
        NSLog(@"Switch is ON");
        dispatch_async(dispatch_get_main_queue(), ^{
            PopoverSettingsViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PopoverSettingsView"];

            controller.modalPresentationStyle = UIModalPresentationCustom;
            controller.tableDataArray = tableDataArray;
            NSDictionary *dict = [notificationArray objectAtIndex:(int) sender.tag];
            if (![Utility isEmptyCheck:dict]) {
                NSString *value = [[dict valueForKey:@"Value"] stringValue];
                if (![Utility isEmptyCheck:value] && value.integerValue > 0) {
                    for (int i = 0;i<tableDataArray.count;i++) {
                        NSDictionary *keyValue = [tableDataArray objectAtIndex:i];
                        if (![Utility isEmptyCheck:[keyValue valueForKey:@"Key"]] && [[keyValue valueForKey:@"Key"] isEqualToString:value]) {
                            controller.selectedIndex = i;
                            break;
                        }else{
                            controller.selectedIndex = -1;
                        }
                    }
                }else{
                    controller.selectedIndex = -1;
                }
            }else{
                controller.selectedIndex = -1;
            }
            controller.settingIndex = (int) sender.tag;
            controller.delegate = self;
            [self presentViewController:controller animated:YES completion:nil];
        });
    }else{
        NSLog(@"Switch is OFF");
        NSDictionary *dict = [[notificationArray objectAtIndex:(int) sender.tag] mutableCopy];
        [dict setValue:[NSNumber numberWithInt:0] forKey:@"Value"];
        [notificationArray replaceObjectAtIndex:(int) sender.tag withObject:dict];
        [notificationSettingTableView reloadData];
    }
}
- (IBAction)unitPreferenceSwitchValueChange:(id)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        PopoverSettingsViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PopoverSettingsView"];
        
        controller.modalPresentationStyle = UIModalPresentationCustom;
        controller.tableDataArray = unitPreferenceArray;
        if (![Utility isEmptyCheck:unitPreferenceArray] && unitPreferenceArray.count > 0) {
            for (int i = 0;i<unitPreferenceArray.count;i++) {
                NSDictionary *keyValue = [unitPreferenceArray objectAtIndex:i];
                if (![Utility isEmptyCheck:[keyValue valueForKey:@"Value"]] && ![Utility isEmptyCheck:[defaults objectForKey:@"unitpreferencevalue"]] && [[keyValue valueForKey:@"Value"] isEqualToString:[defaults objectForKey:@"unitpreferencevalue"]]) {
                    controller.selectedIndex = i;
                    break;
                }else{
                    controller.selectedIndex = -1;
                }
            }
        }else{
            controller.selectedIndex = -1;
        }
        //controller.settingIndex = (int) sender.tag;
        controller.settingIndex = 100;
        controller.delegate = self;
        [self presentViewController:controller animated:YES completion:nil];
    });
}
/*
- (IBAction)unitPreferenceSwitchValueChange:(UISwitch *)sender {
    if([sender isOn]){
        NSLog(@"Switch is ON");
        dispatch_async(dispatch_get_main_queue(), ^{
            PopoverSettingsViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PopoverSettingsView"];
            
            controller.modalPresentationStyle = UIModalPresentationCustom;
            controller.tableDataArray = unitPreferenceArray;
            NSDictionary *dict = [notificationArray objectAtIndex:(int) sender.tag];
            if (![Utility isEmptyCheck:dict]) {
                NSString *value = [[dict valueForKey:@"Value"] stringValue];
                if (![Utility isEmptyCheck:value] && value.integerValue > 0) {
                    for (int i = 0;i<unitPreferenceArray.count;i++) {
                        NSDictionary *keyValue = [unitPreferenceArray objectAtIndex:i];
                        if (![Utility isEmptyCheck:[keyValue valueForKey:@"Key"]] && [[keyValue valueForKey:@"Key"] isEqualToString:value]) {
                            controller.selectedIndex = i;
                            break;
                        }else{
                            controller.selectedIndex = -1;
                        }
                    }
                }else{
                    controller.selectedIndex = -1;
                }
            }else{
                controller.selectedIndex = -1;
            }
            NSLog(@"%ld",(long)sender.tag);
            //controller.settingIndex = (int) sender.tag;
            controller.settingIndex = 100;
            controller.delegate = self;
            [self presentViewController:controller animated:YES completion:nil];
        });
    }else{
        NSLog(@"Switch is OFF");
        NSDictionary *dict = [[notificationArray objectAtIndex:(int) sender.tag] mutableCopy];
        [dict setValue:[NSNumber numberWithInt:0] forKey:@"Value"];
        [notificationArray replaceObjectAtIndex:(int) sender.tag withObject:dict];
        [notificationSettingTableView reloadData];
 
    }
}
*/

- (IBAction)updateCardButtonPressed:(UIButton *)sender {
    NSString *redirectURI = [@"" stringByAppendingFormat:@"%@/event/updatecreditcard",BASEURL];
    
    if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:redirectURI]]){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:redirectURI] options:@{} completionHandler:^(BOOL success) {
            if(success){
                NSLog(@"Opened");
                }
        }];
    }
}

-(IBAction)dobButtonPressed:(id)sender{
    DatePickerViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DatePicker"];
    controller.modalPresentationStyle = UIModalPresentationCustom;
    if (![Utility isEmptyCheck:selectedDate]) {
        controller.selectedDate = selectedDate;
    }
    controller.datePickerMode = UIDatePickerModeDate;
    controller.delegate = self;
    [self presentViewController:controller animated:YES completion:nil];
}
-(IBAction)dailyQuoteValueChange:(UISwitch*)sender{
        dailyQuoteSwitch.on = sender.isOn;
        if(dailyQuoteSwitch.isOn){
            [Utility cancelscheduleLocalNotificationsForQuote];
            [AppDelegate scheduleLocalNotificationsForQuote:NO];
            [defaults setBool:dailyQuoteSwitch.isOn forKey:@"QuoteNotification"];
        }else{
            UIAlertController *alertController = [UIAlertController
                                                  alertControllerWithTitle:@"Alert!"
                                                  message:@"If you turn this feature off you will no longer be sent the quote of the day"
                                                  preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction
                                       actionWithTitle:@"Turn it Off"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction *action)
                                       {
                                           self->dailyQuoteSwitch.on = false;
                                           [Utility cancelscheduleLocalNotificationsForQuote];
                                           [defaults setBool:self->dailyQuoteSwitch.isOn forKey:@"QuoteNotification"];
                                       }];
            UIAlertAction *cancelAction = [UIAlertAction
                                           actionWithTitle:@"Keep it On"
                                           style:UIAlertActionStyleCancel
                                           handler:^(UIAlertAction *action)
                                           {
                self->dailyQuoteSwitch.on = true;
                                               [defaults setBool:self->dailyQuoteSwitch.isOn forKey:@"QuoteNotification"];
                                           }];
            
            [alertController addAction:okAction];
            [alertController addAction:cancelAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }
}
-(IBAction)badgePopUpValueChange:(id)sender{
}

#pragma mark - End

#pragma mark - Private Function
-(void)setUpView{
    
    if([defaults boolForKey:@"isLimeLightUser"]){
        updateCardLabel.hidden = false;
        updateCardButton.hidden = false;
    }else{
        updateCardLabel.hidden = true;
        updateCardButton.hidden = true;
    }
    
    
    saveButton.hidden = true;
    editButton.hidden = false;
    cancelButton.hidden = true;
    editImage.hidden = true;
    displayImageButton.hidden = false;
    
    FirstNameTextField.userInteractionEnabled =false;
    LastNameTextField.userInteractionEnabled =false;
    phoneNumberTextField.userInteractionEnabled = false;
    dateofBirthTextField.userInteractionEnabled=false;
    dobButton.userInteractionEnabled = false;
    passwordTextField.userInteractionEnabled=false;
    confirmPasswordTextField.userInteractionEnabled = false;
    squadCity.userInteractionEnabled=false;
    squadSuburb.userInteractionEnabled =false;
    timeZoneButton.enabled = false;
    receiveWeeklyMailSwitch.userInteractionEnabled = false;
    applyRoundingSwitch.userInteractionEnabled=true;
    unitPreferenceSwitch.userInteractionEnabled=true;
    
    userPreferenceContainerView.hidden = true;
    selectedTimeZoneIndex = -1;
    profileDetailsDict = [[NSMutableDictionary alloc]init];
    apiCallCount = 0;
    dispatch_queue_t myQueue = dispatch_queue_create("My Queue",NULL);
    dispatch_async(myQueue, ^{
        [self getProfileDetails:nil];
        [self getNotificationSettingWebServicecall];
    });
}
- (void)openPhotoAlbum{
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    controller.delegate = self;
    controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:controller animated:YES completion:NULL];
}
-(void)showCamera{
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]){
        // Has camera
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        controller.delegate = self;
        controller.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:controller animated:YES completion:NULL];
    }else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Camera not available" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}
-(void)closeActionsheet{
    NSLog(@"calcelpress");
}

-(void)doneButton{
    [FirstNameTextField resignFirstResponder];
    [LastNameTextField resignFirstResponder];
    [phoneNumberTextField resignFirstResponder];
    [dateofBirthTextField resignFirstResponder];
    [passwordTextField resignFirstResponder];
    [confirmPasswordTextField resignFirstResponder];
}

-(void)updateViewWithProfileData:(NSDictionary *)responseDict{
        profileDataDict = responseDict;
        //squadcity
    if (![Utility isEmptyCheck:[responseDict objectForKey:@"SquadCityList"]]) {
        NSArray *SquadCityList = [responseDict objectForKey:@"SquadCityList"];
        NSString *SquadCityIdString =[responseDict objectForKey:@"SquadCityId"];
        
        NSArray *filteredarray = [SquadCityList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(SquadCityId == %@)", SquadCityIdString]];
        
        NSDictionary *dict = [filteredarray objectAtIndex:0];
        [squadCity setTitle:[dict objectForKey:@"SquadCityName"] forState:UIControlStateNormal];
       }
        //SquadSuburb
    if (![Utility isEmptyCheck:[responseDict objectForKey:@"SquadSuburbsList"]]) {
        NSArray *SquadSuburbList = [responseDict objectForKey:@"SquadSuburbsList"];
        NSString *SquadSuburbIdString =[responseDict objectForKey:@"SquadSuburbId"];
        
        NSArray *filteredSuburbarray = [SquadSuburbList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(SquadSuburbId == %@)", SquadSuburbIdString]];
        
        NSDictionary *suburbdict = [filteredSuburbarray objectAtIndex:0];
        [squadSuburb setTitle:[suburbdict objectForKey:@"SububrsName"] forState:UIControlStateNormal];
      }

        timeZoneArray  = [[NSMutableArray alloc]init];
        NSArray *tempTimezone = [responseDict valueForKey:@"TimeZoneList"];
        selectedTimeZoneIndex = -1;
        NSString *selectedTimeZone = [responseDict objectForKey:@"SelectedTimeZone"];
        if (![Utility isEmptyCheck:[responseDict objectForKey:@"ReceiveQuote"]] && [[responseDict objectForKey:@"ReceiveQuote"] boolValue]) {
            receiveWeeklyMailSwitch.on = true;
        }else{
            receiveWeeklyMailSwitch.on = false;
        }
        
        if (![Utility isEmptyCheck:[responseDict objectForKey:@"apply_rounding"]] )[defaults setObject:[responseDict objectForKey:@"apply_rounding"] forKey:@"ApplyRounding"];
        
        
        if (![Utility isEmptyCheck:[responseDict objectForKey:@"apply_rounding"]] && [[responseDict objectForKey:@"apply_rounding"] boolValue]) {
            applyRoundingSwitch.on = true;
        }else{
            applyRoundingSwitch.on = false;
        }
        if (![Utility isEmptyCheck:[responseDict objectForKey:@"UnitPreference"]]) {
            userPreferenceContainerView.hidden = false;
            
            unitpreferenceValue =[NSString stringWithFormat:@"%@",[responseDict objectForKey:@"UnitPreference"]];
            if ([unitpreferenceValue intValue] == 0) {
                unitpreferenceValue = @"1";
            }
            [defaults setObject:unitpreferenceValue forKey:@"UnitPreference"];
            
            [defaults setObject:unitPreference[unitpreferenceValue] forKey:@"unitpreferencevalue"];
            
            NSLog(@"unitpreferenceValue-%@",[unitPreference objectForKey:unitpreferenceValue]);
            unitPreferenceSubtitle.text =[unitPreference objectForKey:unitpreferenceValue];
            
            unitPreferenceSwitch.on =true;
            
        }else{
            unitPreferenceSwitch.on =false;
            unitPreferenceSubtitle.text=@"METRIC";
        }
        [self.view setNeedsUpdateConstraints];
        //[self sizeHeaderToFit];
    if (![Utility isEmptyCheck:tempTimezone]) {
        for (int i = 0;i < tempTimezone.count; i++) {
                  NSDictionary *zone = [tempTimezone objectAtIndex:i];
                  NSDictionary *temp = [[NSDictionary alloc]initWithObjectsAndKeys:[zone objectForKey:@"TimeZoneId"],@"Key",[zone objectForKey:@"TimeZoneTitle"],@"Value", nil];
                  [timeZoneArray addObject:temp];
                  if (![Utility isEmptyCheck:selectedTimeZone] && [[zone objectForKey:@"TimeZoneId"] isEqualToString:selectedTimeZone]) {
                      [timeZoneButton setTitle:[zone objectForKey:@"TimeZoneTitle"] forState:UIControlStateNormal];
                      selectedTimeZoneIndex = i;
                  }
              }
        }
      
        NSString *detailString = @"";
        NSString *firstName = [responseDict objectForKey:@"FirstName"];
        NSString *laststring = [responseDict objectForKey:@"LastName"];
        if (![Utility isEmptyCheck:firstName] && ![Utility isEmptyCheck:laststring]){
            detailString = [firstName stringByAppendingFormat:@" %@",laststring];
            profileNameLabel.text = detailString;
            
        }
        
        
        if (![Utility isEmptyCheck:firstName]){
            FirstNameTextField .text = firstName;
            [defaults setObject:firstName forKey:@"FirstName"];//add24
        }
        if (![Utility isEmptyCheck:laststring]){
            LastNameTextField .text = laststring;
            [defaults setObject:laststring forKey:@"LastName"];//Added by AY 25042018
        }
        phoneNo = [responseDict objectForKey:@"Phone"];
        if (![Utility isEmptyCheck:phoneNo]){
            if ([phoneNo  isEqual: @"iphone"] || [phoneNo  isEqual:@"android"]){
                phoneNumberTextField.text =@"";
            }
            else{
                phoneNumberTextField.text =phoneNo;
                
            }
        }else{
            phoneNo = @"";
        }
        
        signupVia = [[responseDict objectForKey:@"SignupVia"] intValue];
        cancelSquadSubscription.hidden = false;
        cancelSubscrText.hidden = true;
    
        if([defaults boolForKey:@"IsNonSubscribedUser"]){
            [cancelSquadSubscription setTitle:@"SIGN UP NOW" forState:UIControlStateNormal];
        }else{
            [cancelSquadSubscription setTitle:@"CLICK HERE" forState:UIControlStateNormal];
            if (![Utility isEmptyCheck:[defaults objectForKey:@"TempTrialEndDate"]]) {
                NSDateFormatter *df = [NSDateFormatter new];
                [df setDateFormat:@"yyyy-MM-dd"];
                if ([[df dateFromString:[defaults objectForKey:@"TempTrialEndDate"]] isLaterThanOrEqualTo:[df dateFromString:[df stringFromDate:[NSDate date]]]]) {
                    cancelSquadSubscription.hidden = true;
                    cancelSubscrText.hidden = false;
                    NSDate *date = [df dateFromString:[defaults objectForKey:@"TempTrialEndDate"]];
                    [df setDateFormat:@"dd MMM yyyy"];
                    cancelSubscrText.text = [@"" stringByAppendingFormat:@"Your membership has been cancelled. You have full access until  %@.",[df stringFromDate:date]];
                }
            }
        }
    
        if([Utility isSquadLiteUser]){
            if(signupVia == Web){
                cancelSquadSubscription.hidden = false;
                cancelSubscrText.hidden = true;
             }else{
                 cancelSquadSubscription.hidden = true;
                 cancelSubscrText.hidden = false;
             }
        }
        
    
        
        NSString *dateOfBirth = [responseDict objectForKey:@"DateOfBirth"];
        if (![Utility isEmptyCheck:dateOfBirth]){
            
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            // set the date format related to what the string already you have
            [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
            NSDate *date = [dateFormat dateFromString:dateOfBirth];
            [dateFormat setTimeZone:[NSTimeZone systemTimeZone]];
            // again add the date format what the output u need
            [dateFormat setDateFormat:@"dd/MM/yyyy"];
            NSString *finalDate = [dateFormat stringFromDate:date];
//            dateofBirthTextField.text =finalDate;
            [dobButton setTitle:finalDate forState:UIControlStateNormal];
        }
        
        NSString *password = [responseDict objectForKey:@"Password"];
        if (![Utility isEmptyCheck:password]){
            [defaults setObject:password forKey:@"Password"];
            passwordTextField.text =password;
        }
        
        NSString *confirmPassword = [responseDict objectForKey:@"Password"];
        if (![Utility isEmptyCheck:confirmPassword]){
            confirmPasswordTextField.text =confirmPassword;
        }
        NSString *imageUrlString = [responseDict objectForKey:@"ProfilePicture"];
        if (![Utility isEmptyCheck:imageUrlString]) {
            [defaults setObject:imageUrlString forKey:@"ProfilePicUrl"];
            NSString *imageUrl= [@"" stringByAppendingFormat:@"%@/%@",BASEURL,[responseDict objectForKey:@"ProfilePicture"]];
            
            [profileImage sd_setImageWithURL:[NSURL URLWithString:[imageUrl stringByAddingPercentEncodingWithAllowedCharacters:
                                                                   [NSCharacterSet URLQueryAllowedCharacterSet]]]
                            placeholderImage:[UIImage imageNamed:@"avtarimg.png"]
                                   options:SDWebImageScaleDownLargeImages completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           self->galaryimage = image;
                                       });
                                   }];
            
        }else{
            profileImage.image = [UIImage imageNamed:@"avtarimg.png"];
        }
        [notificationSettingTableView reloadData];
    
        if([Utility isUserLoggedInToChatSdk]){
            [Utility updateUserDetailsToFirebase];
        }
    
    
}


-(void)moveToSignup{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SignupWithEmailViewController *signupController=[storyboard instantiateViewControllerWithIdentifier:@"SignupWithEmail"];
    NSDictionary *userData = [defaults objectForKey:@"NonSubscribedUserData"];
    if (![Utility isEmptyCheck:userData] && ![Utility isEmptyCheck:userData[@"Email"]]) {
        signupController.isFromFb = ![Utility isEmptyCheck:userData[@"IsFbUser"]]?[userData[@"IsFbUser"] boolValue] : NO;
        signupController.fName = ![Utility isEmptyCheck:userData[@"FirstName"]]?userData[@"FirstName"] : @"";
        signupController.lName = ![Utility isEmptyCheck:userData[@"LastName"]]?userData[@"LastName"] : @"";
        signupController.email = userData[@"Email"];
        if (![Utility isEmptyCheck:userData[@"IsFbUser"]] && [userData[@"IsFbUser"] boolValue]) {
            signupController.password = ![Utility isEmptyCheck:userData[@"Password"]]?userData[@"Password"] : @"";
        }else{
            signupController.password =  @"";
        }
        signupController.isFromNonSubscribedUser = YES;
    }
    
    [self.navigationController pushViewController:signupController animated:YES];
    
}



#pragma mark - End

#pragma mark - View Life Cycle
//-(void)viewDidAppear:(BOOL)animated{
//    [super viewDidAppear:YES];
//    profileImage.layer.cornerRadius=profileImage.frame.size.height/2;
//    profileImage.layer.masksToBounds = YES;
//    profileImage.clipsToBounds  = YES;
//
//}
-(void)sizeHeaderToFit{
    UIView *headerView = notificationSettingTableView.tableFooterView;
    
    [headerView setNeedsLayout];
    [headerView layoutIfNeeded];
    
    float height = [headerView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    CGRect frame = headerView.frame;
    frame.size.height = height;
    headerView.frame = frame;
    
    notificationSettingTableView.tableFooterView = headerView;

}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    profileImage.layer.cornerRadius=profileImage.frame.size.height/2;
    profileImage.layer.masksToBounds = YES;
    profileImage.clipsToBounds  = YES;
    [self sizeHeaderToFit];

    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setNeedsUpdateConstraints];
    signupVia = 0;
    NSDictionary *loginData = [defaults objectForKey:@"LoginData"];
    if (![Utility isEmptyCheck:loginData]) {
        if([[loginData objectForKey:@"HasLife"]boolValue] && [[loginData objectForKey:@"HasBootyTrial"]boolValue] && [[loginData objectForKey:@"HasAbsTrial"]boolValue] && [[loginData objectForKey:@"HasLifeTrial"]boolValue]){
            memberActiveLabel.text = @"Trial";
            memberActiveLabel.textColor = [UIColor redColor];
        }else{
            memberActiveLabel.text = @"Active";
            memberActiveLabel.textColor = [UIColor colorWithRed:53.0f/255.0f green:170.0f/255.0f blue:71.0f/255.0f alpha:1];
        }
    }
    if ([[UIScreen mainScreen] bounds].size.height == 480) {
        headerBg.image = [UIImage imageNamed:@"header-4s.png"];
    }else{
        headerBg.image = [UIImage imageNamed:@"header.png"];
    }
    [self registerForKeyboardNotifications];
    
    
//    tableDataArray = [[NSMutableArray alloc]initWithObjects:[[NSDictionary alloc]initWithObjectsAndKeys:@"2 days before",@"Value",@"2880",@"Key", nil],[[NSDictionary alloc]initWithObjectsAndKeys:@"The day before",@"Value",@"1440",@"Key", nil],[[NSDictionary alloc]initWithObjectsAndKeys:@"2 hours before",@"Value",@"120",@"Key", nil],[[NSDictionary alloc]initWithObjectsAndKeys:@"1 hour before",@"Value",@"60",@"Key", nil],[[NSDictionary alloc]initWithObjectsAndKeys:@"30 minutes before",@"Value",@"30",@"Key", nil],[[NSDictionary alloc]initWithObjectsAndKeys:@"5 minutes before",@"Value",@"5",@"Key", nil],nil];
    
    
    tableDataArray = [[NSMutableArray alloc]initWithObjects:
                      [[NSDictionary alloc]initWithObjectsAndKeys:@"1 day prior",@"Value",@"1440",@"Key", nil],
                      [[NSDictionary alloc]initWithObjectsAndKeys:@"2 hours prior",@"Value",@"120",@"Key", nil],
                      [[NSDictionary alloc]initWithObjectsAndKeys:@"1 hour prior",@"Value",@"60",@"Key", nil], nil];
    
    
//    unitPreferenceArray =[[NSMutableArray alloc]initWithObjects:[[NSDictionary alloc]initWithObjectsAndKeys:@"ALL",@"Value",@"0",@"Key", nil],[[NSDictionary alloc]initWithObjectsAndKeys:@"METRIC",@"Value",@"1",@"Key", nil],[[NSDictionary alloc]initWithObjectsAndKeys:@"IMPERIAL",@"Value",@"2",@"Key", nil],nil];
     unitPreferenceArray =[[NSMutableArray alloc]initWithObjects:[[NSDictionary alloc]initWithObjectsAndKeys:@"METRIC",@"Value",@"1",@"Key", nil],[[NSDictionary alloc]initWithObjectsAndKeys:@"IMPERIAL",@"Value",@"2",@"Key", nil],nil];
    
    
    
    editButton.layer.cornerRadius = 3.0;
    editButton.layer.masksToBounds = YES;
    saveButton.layer.cornerRadius = 3.0;
    saveButton.layer.masksToBounds = YES;
    cancelButton.layer.cornerRadius = 3.0;
    cancelButton.layer.masksToBounds = YES;
    saveNotificationButton.layer.cornerRadius = 3.0f;
    
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone  target:self action:@selector(doneButton)],nil];
    [numberToolbar sizeToFit];
    FirstNameTextField.inputAccessoryView=numberToolbar;
    LastNameTextField.inputAccessoryView=numberToolbar;
    phoneNumberTextField.inputAccessoryView=numberToolbar;
    dateofBirthTextField.inputAccessoryView=numberToolbar;
    passwordTextField.inputAccessoryView=numberToolbar;
    confirmPasswordTextField.inputAccessoryView = numberToolbar;
    
    unitPreference = @{
                 @"0":@"ALL",
                 @"1":@"METRIC",
                 @"2":@"IMPERIAL",
                 };

    
    [self setUpView];
    dailyQuoteSwitch.on = [defaults boolForKey:@"QuoteNotification"];
    [applyRoundingSwitch addTarget:self action:@selector(updateRoundingFlag) forControlEvents:UIControlEventValueChanged];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
-(void) updateViewConstraints{
    [super updateViewConstraints];
    notificationSettingTableHeightConstraint.constant = notificationSettingTableView.contentSize.height;
}

#pragma mark - End

#pragma mark - Memory warning

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - End

#pragma mark - Webservicecall

-(void) getNotificationSettingWebServicecall{
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            apiCallCount++;
            if (contentView) {
                [contentView removeFromSuperview];
            }
            contentView = [Utility activityIndicatorView:self];
        });
        NSURLSession *loginSession = [NSURLSession sharedSession];
        
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:[defaults valueForKey:@"UserID"] forKey:@"User_id"];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults valueForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetUserNotificationApiCall" append:@"" forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 self->apiCallCount--;
                                                                 if (contentView && apiCallCount == 0) {
                                                                     [contentView removeFromSuperview];
                                                                 }
                                                                 
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     
                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict]) {
                                                                         NSArray *tempArray =[responseDict valueForKey:@"EventTypeNotification"];
                                                                         if(![Utility isEmptyCheck:tempArray]){
                                                                             notificationArray = [[NSMutableArray alloc]initWithArray:tempArray];
                                                                         }else{
                                                                             notificationArray = [[NSMutableArray alloc]init];
                                                                         }
                                                                         [notificationSettingTableView reloadData];
                                                                         
                                                                         
                                                                     }else{
                                                                         [Utility msg:@"Something is wrong.Please try later." title:@"Error !" controller:self haveToPop:NO];
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

-(void)getProfileDetails:(NSDictionary *)dict{
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self->apiCallCount++;
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
            self->contentView = [Utility activityIndicatorView:self];
        });
        
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]initWithDictionary:dict];
        [mainDict setObject:[defaults valueForKey:@"UserID"] forKey:@"UserID"];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults valueForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetMbhqUserProfile" append:@"" forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 self->apiCallCount--;
                                                                 if (self->contentView && self->apiCallCount == 0) {
                                                                     [self->contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     
                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict]) {
                                                                         if (![Utility isEmptyCheck:[responseDict objectForKey:@"Profile"]]) {
                                                                             [self updateViewWithProfileData:[responseDict objectForKey:@"Profile"]];
                                                                             [Utility communityUpdateUserDataWebserviceCall];

                                                                         }
                                                                         
                                                                         
                                                                     }else{
                                                                         [Utility msg:@"Something is wrong.Please try later." title:@"Error !" controller:self haveToPop:YES];
                                                                         return;
                                                                     }
                                                                 }else{
                                                                     [Utility msg:error.localizedDescription title:@"Error !" controller:self haveToPop:YES];
                                                                 }
                                                             });
                                                         }];
        [dataTask resume];
        
    }else{
        [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:YES];
    }
}
-(void) saveProfileWebServiceCallWithPhoto:(NSString *)dobString {
    if (Utility.reachable) {
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:[defaults valueForKey:@"UserID"] forKey:@"UserID"];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults valueForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"abbbcUserId"];
        
        NSString* firstName = FirstNameTextField.text;
        if (![Utility isEmptyCheck:firstName]) {
            [mainDict setObject:firstName forKey:@"FirstName"];
        }else{
            [Utility msg:@"First Name cannot be blank!" title:@"" controller:self haveToPop:NO];
            return;
        }
        NSString* lastName = LastNameTextField.text;
        if (![Utility isEmptyCheck:lastName]) {
            [mainDict setObject:lastName forKey:@"LastName"];
        }else{
            [Utility msg:@"Last Name cannot be blank!" title:@"" controller:self haveToPop:NO];
            return;
        }
        NSString* password = passwordTextField.text;
        
        BOOL isFbUser = [defaults boolForKey:@"IsFbUser"];

        if (![Utility isEmptyCheck:password]) {
            [mainDict setObject:password forKey:@"NewPassword"];
        }else if(!isFbUser){
            [Utility msg:@"Password cannot be blank!" title:@"" controller:self haveToPop:NO];
            return;
        }
        
        NSString* confirmPassword = confirmPasswordTextField.text;
        if (![Utility isEmptyCheck:confirmPassword] && [password isEqualToString:confirmPassword]) {
            [mainDict setObject:confirmPassword forKey:@"ConfirmPassword"];
        }else if(!isFbUser){
            [Utility msg:@"Confirm Password did not match!" title:@"" controller:self haveToPop:NO];
            return;
        }
//        [mainDict setObject:phoneNo forKey:@"Phone"];
        if(![Utility isEmptyCheck:phoneNumberTextField.text]){
           [mainDict setObject:phoneNumberTextField.text forKey:@"Phone"];     //22/sep/18
        }else{
            [mainDict setObject:@" " forKey:@"Phone"];     //22/sep/18
        }
        
        if (![Utility isEmptyCheck:dobString]) {
            [mainDict setObject:dobString forKey:@"DateOfBirth"];
        }
//        [mainDict setObject:[NSNumber numberWithBool:receiveWeeklyMailSwitch.on] forKey:@"ReceiveQuote"];
        
        //add on
//        [mainDict setObject:[NSNumber numberWithBool:applyRoundingSwitch.on] forKey:@"apply_rounding"];
//        if (![Utility isEmptyCheck:optionUnitValue]) {
//            int unitValue =[optionUnitValue intValue];
//            [mainDict setObject:[NSNumber numberWithInt:unitValue] forKey:@"UnitPreference"];
//
//        }else{
//            NSString *unitKeyValue=@"";
//            NSString *value=unitPreferenceSubtitle.text;
//            if ([value isEqualToString:@"ALL"]) {
//                unitKeyValue=@"0";
//            }else if ([value isEqualToString:@"METRIC"]){
//                unitKeyValue=@"1";
//            }else if ([value isEqualToString:@"IMPERIAL"]){
//                unitKeyValue=@"2";
//            }
//            int unitValue =[unitKeyValue intValue];
//            [mainDict setObject:[NSNumber numberWithInt:unitValue] forKey:@"UnitPreference"];
//        }
        
        if (timeZoneArray.count > 0) {
            NSDictionary *zone = [[NSDictionary alloc] init];
            if (selectedTimeZoneIndex > 0 && selectedTimeZoneIndex < timeZoneArray.count) {
                zone = [timeZoneArray objectAtIndex:selectedTimeZoneIndex];
            }
            if (![Utility isEmptyCheck:zone]) {
                [mainDict setObject:[zone objectForKey:@"Key"] forKey:@"SelectedTimeZone"];
            }
        }
        [mainDict setObject:[NSNumber numberWithInt:2] forKey:@"AppType"];
        [mainDict setObject:@"" forKey:@"PhotoDetail"];
        
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:0  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        ProgressBarViewController *controller=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ProgressBar"];
        controller.delegate=self;
        controller.apiName=@"ManageProfileWithPhoto";
        controller.appendString=@"";
        controller.jsonString=jsonString;
        controller.chosenImage=galaryimage;
        controller.modalPresentationStyle = UIModalPresentationCustom;
        [self presentViewController:controller animated:YES completion:nil];
    }else{
        [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
    }
    
}
-(void)saveProfileWebServiceCall{
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
        [mainDict setObject:[defaults valueForKey:@"UserID"] forKey:@"UserID"];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults valueForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        
        NSString* firstName = FirstNameTextField.text;
        NSString* lastName = LastNameTextField.text;
        [mainDict setObject:firstName forKey:@"FirstName"];
        [mainDict setObject:lastName forKey:@"LastName"];
        [mainDict setObject:passwordTextField.text forKey:@"NewPassword"];
        [mainDict setObject:confirmPasswordTextField.text forKey:@"ConfirmPassword"];
        [mainDict setObject:phoneNumberTextField.text forKey:@"Phone"];
        [mainDict setObject:[NSNumber numberWithBool:receiveWeeklyMailSwitch.on] forKey:@"ReceiveQuote"];
        
        //add on
        [mainDict setObject:[NSNumber numberWithBool:applyRoundingSwitch.on] forKey:@"apply_rounding"];
        if (![Utility isEmptyCheck:optionUnitValue]) {
            int unitValue =[optionUnitValue intValue];
            [mainDict setObject:[NSNumber numberWithInt:unitValue] forKey:@"UnitPreference"];

        }else{
            NSString *unitKeyValue=@"";
            NSString *value=unitPreferenceSubtitle.text;
            if ([value isEqualToString:@"ALL"]) {
                unitKeyValue=@"0";
            }else if ([value isEqualToString:@"METRIC"]){
                 unitKeyValue=@"1";
            }else if ([value isEqualToString:@"IMPERIAL"]){
                unitKeyValue=@"2";
            }
            int unitValue =[unitKeyValue intValue];
            [mainDict setObject:[NSNumber numberWithInt:unitValue] forKey:@"UnitPreference"];
        }
        
        if (timeZoneArray.count > 0) {
            NSDictionary *zone = [[NSDictionary alloc] init];
            if (selectedTimeZoneIndex > 0 && selectedTimeZoneIndex < timeZoneArray.count) {
                zone = [timeZoneArray objectAtIndex:selectedTimeZoneIndex];
            }
            if (![Utility isEmptyCheck:zone]) {
                [mainDict setObject:[zone objectForKey:@"Key"] forKey:@"SelectedTimeZone"];
            }
        }
        
//        [mainDict setObject:dateofBirthTextField.text forKey:@"DateOfBirth"];
        [mainDict setObject:dobButton.titleLabel.text forKey:@"DateOfBirth"];
        
        NSData *dataImage = [[NSData alloc] init];
        NSString *stringImage = @"";
        if (galaryimage) {
            dataImage = UIImagePNGRepresentation(galaryimage);
            stringImage = [dataImage base64EncodedStringWithOptions:0];
        }
        [mainDict setObject:stringImage forKey:@"PhotoDetail"];
        
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:0  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"ManageProfile" append:@"" forAction:@"POST"];
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
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict]) {
                                                                         UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Your details have been updated" preferredStyle:UIAlertControllerStyleAlert];
                                                                         
                                                                         UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                                                                         [alertController addAction:ok];
                                                                         [self presentViewController:alertController animated:YES completion:nil];
                                                                         [self setUpView];
                                                                     }else{
                                                                         [Utility msg:@"Something is wrong.Please try later." title:@"Error !" controller:self haveToPop:NO];
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
-(void)makeUserLogin{
    
    NSString *email = [defaults objectForKey:@"Email"];
    NSString *password = [defaults objectForKey:@"Password"];
    
    if(![Utility isEmptyCheck:email]){
        if (![Utility validateEmail:email]) {
            [Utility msg:@"Please enter a valid email." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        
    }else{
        [Utility msg:@"Please enter your email." title:@"Oops" controller:self haveToPop:NO];
        return;
    }
    if([Utility isEmptyCheck:password]){
        [Utility msg:@"Please enter your password." title:@"Oops" controller:self haveToPop:NO];
        return;
    }
    
    if (Utility.reachable) {
        //[Utility logoutChatSdk];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
            self->contentView = [Utility activityIndicatorView:self];
        });
        NSURLSession *loginSession = [NSURLSession sharedSession];
        
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:email forKey:@"EmailAddress"];
        [mainDict setObject:password forKey:@"Password"];
        [mainDict setObject:[NSNumber numberWithBool:true] forKey:@"IncludeAbbbcOnline"];
        
        if ([defaults boolForKey:@"IsFbUser"]) {
            if(![Utility isEmptyCheck:[defaults objectForKey:@"facebookTokenString"]]){
                NSString *fbToken =[defaults objectForKey:@"facebookTokenString"];
                [mainDict setObject:fbToken forKey:@"FacebookToken"];
            }
        }
        
        //Added on AY 17042018
        NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        if(![Utility isEmptyCheck:version]){
            [mainDict setObject:version forKey:@"AppVersion"];
        }
        [mainDict setObject:@"ios" forKey:@"AppPlatform"];
        //End
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"LogInApiCall" append:@"" forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(),^ {
                                                                 if (self->contentView) {
                                                                     [self->contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     
                                                                     
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSMutableDictionary *responseDictionary = [[NSJSONSerialization JSONObjectWithData:data options:0 error:nil] mutableCopy];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDictionary]) {
                                                                         for (NSString *key in [responseDictionary allKeys]) {
                                                                             if ([[responseDictionary objectForKey:key] class] ==[NSNull class]) {
                                                                                 [responseDictionary removeObjectForKey:key];
                                                                             }
                                                                         }
                                                                         
                                                                         
                                                                         [defaults setBool:[[responseDictionary valueForKey:@"isLimeLightUser"] boolValue] forKey:@"isLimeLightUser"];
                                                                         
                                                                         [defaults setObject:[responseDictionary valueForKey:@"ActiveUntil"] forKey:@"TempTrialEndDate"];
                                                                         [defaults setBool:YES forKey:@"CompletedStartupChecklist"]; //AmitY
                                                                         
                                                                         [defaults setBool:false forKey:@"IsNonSubscribedUser"];
                                                                         [defaults setObject:[responseDictionary valueForKey:@"EmailAddress"] forKey:@"Email"];
                                                                         [defaults   setObject:password forKey:@"Password"];
                                                                         [defaults setObject:responseDictionary forKey:@"LoginData"];
                                                                         [defaults setObject:[responseDictionary valueForKey:@"UserID"] forKey:@"UserID"];
                                                                         [defaults setObject:[responseDictionary valueForKey:@"UserSessionID"] forKey:@"UserSessionID"];
                                                                         [defaults setObject:[responseDictionary valueForKey:@"ABBBCOnlineUserId"] forKey:@"ABBBCOnlineUserId"];
                                                                         
                                                                         if(![Utility isEmptyCheck:responseDictionary[@"ProfilePicUrl"]]){
                                                                             [defaults setObject:responseDictionary[@"ProfilePicUrl"] forKey:@"ProfilePicUrl"];
                                                                         }
                                                                         
                                                                         [defaults setObject:[responseDictionary valueForKey:@"FirstName"] forKey:@"FirstName"];//add24
                                                                         
                                                                         [defaults setObject:[responseDictionary valueForKey:@"LastName"] forKey:@"LastName"];//Added by AY 25042018
                                                                         
                                                                         [defaults setObject:[responseDictionary valueForKey:@"ABBBCOnlineUserSessionId"] forKey:@"ABBBCOnlineUserSessionId"];
                                                                         
                                                                         [defaults setObject:[responseDictionary valueForKey:@"FbWorldForumUrl"] forKey:@"FbWorldForumUrl"];
                                                                         [defaults setObject:[responseDictionary valueForKey:@"FbCityForumUrl"] forKey:@"FbCityForumUrl"];
                                                                         [defaults setObject:[responseDictionary valueForKey:@"FbSuburbForumUrl"] forKey:@"FbSuburbForumUrl"];
                                                                         
                                                                         NSString *disStat = ([[responseDictionary valueForKey:@"DiscoverableStatus"] boolValue]) ? @"yes" : @"no";
                                                                         [defaults setObject:disStat forKey:@"Discoverable"];
                                                                         [defaults setObject:[responseDictionary valueForKey:@"FirebaseToken"] forKey:@"FirebaseToken"];
                                                                         
                                                                         int access_level = [[responseDictionary valueForKey:@"access_level"] intValue];
                                                                         
                                                                         if(access_level == 2){
                                                                             [defaults setBool:true forKey:@"isSquadLite"];
                                                                             [defaults setBool:true forKey:@"CompletedStartupChecklist"];
                                                                         }else{
                                                                             [defaults setBool:false forKey:@"isSquadLite"];
                                                                         }
                                                                         
                                                                         if(![Utility isEmptyCheck:responseDictionary[@"LifeToken"]]){
                                                                             
                                                                             NSMutableDictionary *dict = [NSMutableDictionary new];
                                                                             [dict setObject:responseDictionary[@"LifeToken"] forKey:@"LifeToken"];
                                                                             [dict setObject:[NSDate date] forKey:@"ExpiryDate"];
                                                                             
                                                                             [defaults setObject:dict forKey:@"LifeTokenDetails"];
                                                                             
                                                                         }
                                                                         
                                                                         int signupVia = [[responseDictionary objectForKey:@"SignupMethod"] intValue];
                                                                         
                                                                         [defaults setObject:[NSNumber numberWithInt:signupVia] forKey:@"SignupVia"];
                                                                         
                                                                         [self clickHere:0];
                                                                         
                                                                         
                                                                     }else{
                                                                         
                                                                         
                                                                         if (![Utility isEmptyCheck:responseString]) {
                                                                             [Utility msg:responseString title:@"Error !" controller:self haveToPop:NO];
                                                                         }else{
                                                                             [Utility msg:@"Email or Password is not correct.Please enter correct Email & Password and try again." title:@"Error !" controller:self haveToPop:NO];
                                                                         }
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
-(void)updateUnitPreference{
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
        [mainDict setObject:[defaults valueForKey:@"UserID"] forKey:@"SquadUserId"];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults valueForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"AbbbcUserId"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"AbbbcUserSessionId"];
        
        if (![Utility isEmptyCheck:optionUnitValue]) {
            int unitValue =[optionUnitValue intValue];
            [mainDict setObject:[NSNumber numberWithInt:unitValue] forKey:@"UnitPreference"];
            
        }else{
            NSString *unitKeyValue=@"";
            NSString *value=unitPreferenceSubtitle.text;
            if ([value isEqualToString:@"ALL"]) {
                unitKeyValue=@"0";
            }else if ([value isEqualToString:@"METRIC"]){
                unitKeyValue=@"1";
            }else if ([value isEqualToString:@"IMPERIAL"]){
                unitKeyValue=@"2";
            }
            int unitValue =[unitKeyValue intValue];
            [mainDict setObject:[NSNumber numberWithInt:unitValue] forKey:@"UnitPreference"];
        }
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:0  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"UpdateUnitPreference" append:@"" forAction:@"POST"];
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
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [responseDict[@"Success"]boolValue]) {
                                                                         [self setUpView];
                                                                         [Utility msg:@"My Preferences updated successfully" title:@"" controller:self haveToPop:NO];
                                                                     }else{
                                                                         [Utility msg:@"Something is wrong.Please try later." title:@"Error !" controller:self haveToPop:NO];
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
-(void)updateRoundingFlag{
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
        [mainDict setObject:[defaults valueForKey:@"UserID"] forKey:@"SquadUserId"];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults valueForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"AbbbcUserId"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"AbbbcUserSessionId"];
        [mainDict setObject:[NSNumber numberWithBool:applyRoundingSwitch.on] forKey:@"ApplyRounding"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:0  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"UpdateRoundingFlag" append:@"" forAction:@"POST"];
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
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [responseDict[@"Success"]boolValue]) {
                                                                         [self setUpView];
                                                                         [Utility msg:@"My Preferences updated successfully" title:@"" controller:self haveToPop:NO];
                                                                     }else{
                                                                         [Utility msg:@"Something is wrong.Please try later." title:@"Error !" controller:self haveToPop:NO];
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

#pragma mark- TextField Delegate
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
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    mainScroll.contentInset = contentInsets;
    mainScroll.scrollIndicatorInsets = contentInsets;
    CGRect aRect = mainScroll.frame;
    float x;
    if (activeTextView==nil) {
        x=aRect.size.height-activeTextField.frame.origin.y-activeTextField.frame.size.height;
        aRect.size.height -= kbSize.height;
        if (x < kbSize.height) {
            CGPoint scrollPoint = CGPointMake(0.0, kbSize.height+5-x);
            [mainScroll setContentOffset:scrollPoint animated:YES];
        }
    }
    else{
        x=aRect.size.height-activeTextView.superview.frame.origin.y-activeTextView.superview.frame.size.height;
        aRect.size.height -= kbSize.height;
        if (x < kbSize.height) {
            CGPoint scrollPoint = CGPointMake(0.0, kbSize.height+5-x);
            [mainScroll setContentOffset:scrollPoint animated:YES];
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    activeTextField = textField;
    activeTextView=nil;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    activeTextField = nil;
}
- (void)textViewDidBeginEditing:(UITextView *)textView{
    activeTextView=textView;
    activeTextField=nil;
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    activeTextView=nil;
}
#pragma mark - UIImagePickerControllerDelegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    //galaryimage=[Utility scaleImage:image width:profileImage.frame.size.width height:profileImage.frame.size.width];
    galaryimage=[Utility resizeImage:image withMaxDimension:600];
    
    //galaryimage=image;
    [picker dismissViewControllerAnimated:YES completion:^{
        profileImage.image = galaryimage;
    }];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - End

#pragma mark - TableView Datasource & Delegates
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return notificationArray.count;
}
/*
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIScreen *mainscreen = [UIScreen mainScreen];
    UIView *footer=[[UIView alloc] initWithFrame:CGRectMake(0,0,mainscreen.bounds.size.width,55)];
    footer.layer.backgroundColor = [UIColor whiteColor].CGColor;
    
    UIView *footersubView=[[UIView alloc] initWithFrame:CGRectMake(0,0,mainscreen.bounds.size.width,55)];
    UILabel *preferenceLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 17, 200, 20)];
    [preferenceLabel setFont:[UIFont fontWithName:@"Raleway-Regular" size:17]];
    [preferenceLabel setTextColor:[UIColor blackColor]];
    [preferenceLabel setText:@"Unit Preference"];
    
    preferenceValueLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 40, 200, 20)];
    [preferenceValueLabel setTextColor:[UIColor blackColor]];
    [preferenceValueLabel setText:[unitPreference objectForKey:unitpreferenceValue]];
    [preferenceValueLabel setFont:[UIFont fontWithName:@"Raleway-Light" size:15]];
   
    preferenceSwitch.onTintColor=[Utility colorWithHexString:@"7DC8DF"];
    /*
    if (![Utility isEmptyCheck:unitpreferenceValue]) {
        preferenceSwitch.on=true;
    }else{
        preferenceSwitch.on=false;
    }

    [preferenceSwitch addTarget:self action:@selector(unitPreferenceSwitchValueChange:) forControlEvents:UIControlEventValueChanged];
    
    [footersubView addSubview:preferenceLabel];
    [footersubView addSubview:preferenceValueLabel];
    [footersubView addSubview:preferenceSwitch];

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:preferenceSwitch
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:footersubView
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:preferenceSwitch
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:footersubView
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:preferenceSwitch
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:footersubView
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:preferenceSwitch
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:footersubView
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:0.0]];
    preferenceSwitch.translatesAutoresizingMaskIntoConstraints = NO;

    
    

    [footer addSubview:footersubView];
    return footer;
}
*/
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier =@"NotificationSetting";
    NotificationSettingTableViewCell *cell = (NotificationSettingTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[NotificationSettingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.settingSwitch.tag = (int) indexPath.row;
    NSDictionary *dict = [notificationArray objectAtIndex:indexPath.row];
    if (![Utility isEmptyCheck:dict]) {
        NSString *name = [dict valueForKey:@"Key"];
        if (![Utility isEmptyCheck:name]) {
            cell.settingTitle.text = [name stringByReplacingOccurrencesOfString:@"_" withString:@" "];
        }
        NSString *value = [[dict valueForKey:@"Value"] stringValue ];
        if (![Utility isEmptyCheck:value] && value.integerValue > 0) {
            for (NSDictionary *keyValue in tableDataArray) {
                if (![Utility isEmptyCheck:[keyValue valueForKey:@"Key"]] && [[keyValue valueForKey:@"Key"] isEqualToString:value]) {
                    cell.settingSubtitle.text = [keyValue valueForKey:@"Value"];
                    cell.settingSwitch.on = YES;
                    break;
                }
            }
            
        }else{
            cell.settingSubtitle.text = @"";
            cell.settingSwitch.on = NO;
            
        }
    }
    [self.view setNeedsUpdateConstraints];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    dispatch_async(dispatch_get_main_queue(), ^{
        PopoverSettingsViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PopoverSettingsView"];

        controller.modalPresentationStyle = UIModalPresentationCustom;
        controller.tableDataArray = tableDataArray;
        NSDictionary *dict = [notificationArray objectAtIndex:indexPath.row];
        if (![Utility isEmptyCheck:dict]) {
            NSString *value = [[dict valueForKey:@"Value"] stringValue];
            if (![Utility isEmptyCheck:value] && value.integerValue > 0) {
                for (int i = 0;i<tableDataArray.count;i++) {
                    NSDictionary *keyValue = [tableDataArray objectAtIndex:i];
                    if (![Utility isEmptyCheck:[keyValue valueForKey:@"Key"]] && [[keyValue valueForKey:@"Key"] isEqualToString:value]) {
                        controller.selectedIndex = i;
                        break;
                    }else{
                        controller.selectedIndex = -1;
                    }
                }
            }else{
                controller.selectedIndex = -1;
            }
        }else{
            controller.selectedIndex = -1;
        }
        controller.settingIndex = (int) indexPath.row;
        controller.delegate = self;
        [self presentViewController:controller animated:YES completion:nil];
    });
    
}
#pragma mark - End

#pragma mark - PopoverViewDelegate
- (void) didSelectAnyOption:(int)settingIndex option:(NSString *)option{
    if (settingIndex == 100) {
         unitpreferenceValue =[unitPreference objectForKey:option];
         optionUnitValue =option;
        dispatch_async(dispatch_get_main_queue(), ^{
            self->unitPreferenceSubtitle.text = self->unitpreferenceValue;//change
            [defaults setObject:self->unitpreferenceValue forKey:@"unitpreferencevalue"]; //change
            [self.view needsUpdateConstraints];
        });
        [self updateUnitPreference];
    }else{
        NSDictionary *dict = [[notificationArray objectAtIndex:settingIndex] mutableCopy];
        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
        f.numberStyle = NSNumberFormatterDecimalStyle;
        NSNumber *myNumber = [f numberFromString:option];
        [dict setValue:myNumber forKey:@"Value"];
        [notificationArray replaceObjectAtIndex:settingIndex withObject:dict];
        [notificationSettingTableView reloadData];
    }
    
}
- (void) didSelectAnyOptionWithSender:(UIButton *)sender index:(int)index{
    if (timeZoneArray.count > 0) {
        NSDictionary *zone = [timeZoneArray objectAtIndex:index];
        if (![Utility isEmptyCheck:zone]) {
            [timeZoneButton setTitle:[zone objectForKey:@"Value"] forState:UIControlStateNormal];
            selectedTimeZoneIndex = index;
        }
    }
}
-(void)didCancelOption{
    [notificationSettingTableView reloadData];
}
#pragma mark progressbar delegate

- (void) completedWithResponse:(NSString *)responseString responseDict:(NSDictionary *)responseDict{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"SuccessFlag"] boolValue]) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Your details have been updated" preferredStyle:UIAlertControllerStyleAlert];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateBadgePoint" object:self];//gami_badge_popup
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:ok];
            [self presentViewController:alertController animated:YES completion:nil];
            [self setUpView];
        }else{
            if(![Utility isEmptyCheck:responseDict[@"ErrorMessage"]]){
                [Utility msg:responseDict[@"ErrorMessage"] title:@"Error !" controller:self haveToPop:NO];
            }else{
                [Utility msg:responseString title:@"Error !" controller:self haveToPop:NO];
            }
            
            return;
        }
    });
}


- (void) completedWithError:(NSError *)error{
    [Utility msg:error.localizedDescription title:@"Error !" controller:self haveToPop:NO];
}
#pragma mark - End

#pragma  mark -DatePickerViewControllerDelegate
-(void)didSelectDate:(NSDate *)date{
    NSLog(@"%@",date);
    if (date) {
        static NSDateFormatter *dateFormatter;
        dateFormatter = [NSDateFormatter new];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
        selectedDate = date;
        [dateFormatter setDateFormat:@"dd/MM/yyyy"];// MMM d yyyy
        NSString *dateString = [dateFormatter stringFromDate:date];
        [dobButton setTitle:dateString forState:UIControlStateNormal];
    }
}



@end
