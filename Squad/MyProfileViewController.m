//
//  MyProfileViewController.m
//  The Life
//
//  Created by AQB Solutions-Mac Mini 2 on 31/08/16.
//  Copyright © 2016 AQB Solutions. All rights reserved.
//

#import "MyProfileViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ProfileTableViewCell.h"
#import "NotificationSettingTableViewCell.h"
#import "DisplayImageViewController.h"

@interface MyProfileViewController ()
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
    IBOutlet UIButton *saveNotificationButton;
    
    UIView *contentView;
    NSMutableDictionary *profileDetailsDict;
    IBOutlet UIImageView *profileImage;
    UITextField *activeTextField;
    IBOutlet UIScrollView *mainScroll;
    UITextView *activeTextView;
    NSMutableArray *tableDataArray;
    UIImage *galaryimage;
    
    
    IBOutlet UITableView *notificationSettingTableView;
    IBOutlet NSLayoutConstraint *notificationSettingTableHeightConstraint;
    NSMutableArray *notificationArray;
    int apiCallCount;
    NSMutableArray *timeZoneArray;
    int selectedTimeZoneIndex;
    
}
@end

@implementation MyProfileViewController

#pragma mark - IBAction
- (IBAction)profileImageButtonSelect:(id)sender{
    DisplayImageViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"DisplayImage"];
    controller.modalPresentationStyle = UIModalPresentationCustom;
    controller.image = galaryimage;
    [self presentViewController:controller animated:YES completion:nil];
}
- (IBAction)timeZoneButtonPressed:(UIButton *)sender {
    PopoverSettingsViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"PopoverSettings"];
    controller.modalPresentationStyle = UIModalPresentationCustom;
    controller.tableDataArray = timeZoneArray;
    controller.sender = sender;
    controller.selectedIndex = selectedTimeZoneIndex;
    controller.delegate = self;
    [self presentViewController:controller animated:YES completion:nil];
}

- (IBAction)showMenu:(id)sender {
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
    [self.slidingViewController resetTopViewAnimated:YES];
}



- (IBAction)saveButtonPressed:(id)sender {
    [self doneButton];
    
    NSString *dateStr=dateofBirthTextField.text;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd/MM/yyyy"];
    NSDate *date = [dateFormat dateFromString:dateStr];
    [dateFormat setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    
    NSDate *today = [NSDate date]; // it will give you current date
    NSDate *newDate = date; // your date
    NSComparisonResult result;
    //has three possible values: NSOrderedSame,NSOrderedDescending, NSOrderedAscending
    result = [today compare:newDate]; // comparing two dates
    
    if(result==NSOrderedAscending){
        NSLog(@"today is less");
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Date is not valid" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        [self presentViewController:alertController animated:YES completion:nil];
    }else{
        NSLog(@"Both dates are same");
        [self saveProfileWebServiceCall];
    }

}

- (IBAction)checkUncheckButtonPressed:(UIButton*)sender {
    
}

- (IBAction)editprofilebuttonPressed:(id)sender {
    profileDetailsDict = [[NSMutableDictionary alloc]init];
    FirstNameTextField.userInteractionEnabled = true;
    LastNameTextField.userInteractionEnabled = true;

    phoneNumberTextField.userInteractionEnabled = true;
    dateofBirthTextField.userInteractionEnabled = true;
    passwordTextField.userInteractionEnabled = true;
    confirmPasswordTextField.userInteractionEnabled=true;
    receiveWeeklyMailSwitch.userInteractionEnabled = true;
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
    if ([Utility isEmptyCheck:notificationArray]) {
        return;
    }
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
                                                                 if (contentView) {
                                                                     [contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     
                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict]) {
                                                                         [Utility msg:@"Notification Setting Saved Successfully." title:@"Success" controller:self haveToPop:NO];
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
- (IBAction)receivedWeeklyMailSwitchValueChanged:(UISwitch *)sender {
}
- (IBAction)notificationSettingSwitchValueChange:(UISwitch *)sender {
    if([sender isOn]){
        NSLog(@"Switch is ON");
        dispatch_async(dispatch_get_main_queue(), ^{
            PopoverSettingsViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"PopoverSettings"];
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
#pragma mark - End

#pragma mark - Private Function
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



#pragma mark - End

#pragma mark - View Life Cycle
//-(void)viewDidAppear:(BOOL)animated{
//    [super viewDidAppear:YES];
//    profileImage.layer.cornerRadius=profileImage.frame.size.height/2;
//    profileImage.layer.masksToBounds = YES;
//    profileImage.clipsToBounds  = YES;
//    
//}
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    profileImage.layer.cornerRadius=profileImage.frame.size.height/2;
    profileImage.layer.masksToBounds = YES;
    profileImage.clipsToBounds  = YES;

}

- (void)viewDidLoad {
    [super viewDidLoad];
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
    selectedTimeZoneIndex = -1;
    if ([[UIScreen mainScreen] bounds].size.height == 480) {
        headerBg.image = [UIImage imageNamed:@"header-4s.png"];
    }else{
        headerBg.image = [UIImage imageNamed:@"header.png"];
    }
    [self registerForKeyboardNotifications];
    profileDetailsDict = [[NSMutableDictionary alloc]init];

    tableDataArray = [[NSMutableArray alloc]initWithObjects:[[NSDictionary alloc]initWithObjectsAndKeys:@"2 days before",@"Value",@"2280",@"Key", nil],[[NSDictionary alloc]initWithObjectsAndKeys:@"The day before",@"Value",@"1440",@"Key", nil],[[NSDictionary alloc]initWithObjectsAndKeys:@"2 hours before",@"Value",@"120",@"Key", nil],[[NSDictionary alloc]initWithObjectsAndKeys:@"1 hour before",@"Value",@"60",@"Key", nil],[[NSDictionary alloc]initWithObjectsAndKeys:@"30 minutes before",@"Value",@"30",@"Key", nil],[[NSDictionary alloc]initWithObjectsAndKeys:@"5 minutes before",@"Value",@"5",@"Key", nil],nil];

    receiveWeeklyMailSwitch.userInteractionEnabled = false;
    
    FirstNameTextField.userInteractionEnabled =false;
    LastNameTextField.userInteractionEnabled =false;
    phoneNumberTextField.userInteractionEnabled = false;
    dateofBirthTextField.userInteractionEnabled=false;
    passwordTextField.userInteractionEnabled=false;
    confirmPasswordTextField.userInteractionEnabled = false;
    
    editButton.layer.cornerRadius = 3.0;
    saveButton.layer.cornerRadius = 3.0;
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
    apiCallCount = 0;
    dispatch_queue_t myQueue = dispatch_queue_create("My Queue",NULL);
    dispatch_async(myQueue, ^{
        [self getProfileDetails:nil];
        [self getNotificationSettingWebServicecall];
    });

    
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
                                                                 apiCallCount--;
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
            apiCallCount++;
            if (contentView) {
                [contentView removeFromSuperview];
            }
            contentView = [Utility activityIndicatorView:self];
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
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetProfile" append:@"" forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 apiCallCount--;
                                                                 if (contentView && apiCallCount == 0) {
                                                                     [contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     
                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict]) {
                                                                         timeZoneArray  = [[NSMutableArray alloc]init];
                                                                         NSArray *tempTimezone = [responseDict valueForKey:@"TimeZoneList"];
                                                                         selectedTimeZoneIndex = -1;
                                                                         NSString *selectedTimeZone = [responseDict objectForKey:@"SelectedTimeZone"];
                                                                         if (![Utility isEmptyCheck:[responseDict objectForKey:@"ReceiveQuote"]] && [[responseDict objectForKey:@"ReceiveQuote"] boolValue]) {
                                                                             receiveWeeklyMailSwitch.on = true;
                                                                         }else{
                                                                             receiveWeeklyMailSwitch.on = false;
                                                                         }
                                                                         for (int i = 0;i < tempTimezone.count; i++) {
                                                                             NSDictionary *zone = [tempTimezone objectAtIndex:i];
                                                                             NSDictionary *temp = [[NSDictionary alloc]initWithObjectsAndKeys:[zone objectForKey:@"TimeZoneId"],@"Key",[zone objectForKey:@"TimeZoneTitle"],@"Value", nil];
                                                                             [timeZoneArray addObject:temp];
                                                                             if (![Utility isEmptyCheck:selectedTimeZone] && [[zone objectForKey:@"TimeZoneId"] isEqualToString:selectedTimeZone]) {
                                                                                 [timeZoneButton setTitle:[zone objectForKey:@"TimeZoneTitle"] forState:UIControlStateNormal];
                                                                                 selectedTimeZoneIndex = i;
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
                                                                         }
                                                                         if (![Utility isEmptyCheck:laststring]){
                                                                             LastNameTextField .text = laststring;
                                                                         }
                                                                         NSString *phoneNumber = [responseDict objectForKey:@"Phone"];
                                                                         if (![Utility isEmptyCheck:phoneNumber]){
                                                                             phoneNumberTextField.text =phoneNumber;
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
                                                                             dateofBirthTextField.text =finalDate;
                                                                         }
                                                                         
                                                                         NSString *password = [responseDict objectForKey:@"Password"];
                                                                         if (![Utility isEmptyCheck:password]){
                                                                             passwordTextField.text =password;
                                                                         }
                                                                         
                                                                         NSString *confirmPassword = [responseDict objectForKey:@"Password"];
                                                                         if (![Utility isEmptyCheck:confirmPassword]){
                                                                             confirmPasswordTextField.text =confirmPassword;
                                                                         }
                                                                         NSString *imageUrlString = [responseDict objectForKey:@"ProfilePicture"];
                                                                         if (![Utility isEmptyCheck:imageUrlString]) {
                                                                             NSString *imageUrl= [@"" stringByAppendingFormat:@"%@/%@",BASEURL,[responseDict objectForKey:@"ProfilePicture"]];
                                                                             
                                                                             [profileImage sd_setImageWithURL:[NSURL URLWithString:[imageUrl stringByAddingPercentEncodingWithAllowedCharacters:
                                                                                                                                      [NSCharacterSet URLQueryAllowedCharacterSet]]]
                                                                                               placeholderImage:[UIImage imageNamed:@"avtarimg.png"]
                                                                                                      completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                                                                                          dispatch_async(dispatch_get_main_queue(), ^{
                                                                                                              galaryimage = image;
                                                                                                          });
                                                                                                      }];
                                                                             
                                                                         }else{
                                                                             profileImage.image = [UIImage imageNamed:@"avtarimg.png"];
                                                                         }
                                                                         
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

        
        if (timeZoneArray.count > 0) {
            NSDictionary *zone = [timeZoneArray objectAtIndex:selectedTimeZoneIndex];
            if (![Utility isEmptyCheck:zone]) {
                [mainDict setObject:[zone objectForKey:@"Key"] forKey:@"SelectedTimeZone"];
            }
        }
    
        [mainDict setObject:dateofBirthTextField.text forKey:@"DateOfBirth"];
    
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
        PopoverSettingsViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"PopoverSettings"];
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
    NSDictionary *dict = [[notificationArray objectAtIndex:settingIndex] mutableCopy];
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber *myNumber = [f numberFromString:option];
    [dict setValue:myNumber forKey:@"Value"];
    [notificationArray replaceObjectAtIndex:settingIndex withObject:dict];
    [notificationSettingTableView reloadData];

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
#pragma mark - End




@end
