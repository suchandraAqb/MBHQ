//
//  AccountabilityBuddyHomeViewController.m
//  Squad
//
//  Created by AQB Solutions Private Limited on 03/10/18.
//  Copyright © 2018 AQB Solutions. All rights reserved.
//

#import "AccountabilityBuddyHomeViewController.h"
#import "MyBuddiesListViewController.h"
#import "FindMeABuddyListViewController.h"
#import "SearchBuddyListViewController.h"
#import "AddYourselfBuddyViewController.h"

@interface AccountabilityBuddyHomeViewController (){
    
    IBOutletCollection(UIView) NSArray *borderViews;
    __weak IBOutlet UIButton *friendRequestButton;
    IBOutlet UIScrollView *scroll;
    UIView *contentView;
    NSArray *accountabilityBuddiesArray;
    NSArray *requestArray;
    
    __weak IBOutlet UIView *sendEmailRequestView;
    __weak IBOutlet UIView *emailRequestBodyView;
    __weak IBOutlet UITextField *emailTextField;
    UITextField *activeTextField;
    
}

@end

@implementation AccountabilityBuddyHomeViewController
#pragma mark-View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self registerForKeyboardNotifications];
    [self setupView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self GetbuddyListApiCall];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark-End
#pragma mark - Web Service Call
-(void) GetbuddyListApiCall{
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
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetbuddyList" append:@""forAction:@"POST"];
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
                                                                      NSLog(@"responseDict: \n %@",responseDict);
                                                                      if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"SuccessFlag"]boolValue]) {
                                                                          NSArray *tempArray =[responseDict objectForKey:@"FriendListDetail"];
                                                                          self->accountabilityBuddiesArray = [tempArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(StatusFromFriend == %d)", 0]];
                                                                          NSLog(@"%@",self->accountabilityBuddiesArray);
                                                                          self->requestArray =[tempArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(StatusFromFriend == %d)", 1]];
                                                                          if(self->requestArray.count >0){
                                                                              self->friendRequestButton.badgeValue = [NSString stringWithFormat:@"%i", (int) self->requestArray.count];
                                                                          }else{
                                                                              self->friendRequestButton.badgeValue = @"0";
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
-(void)sendFriendRequest:(NSString *)email{
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
        [mainDict setObject:email forKey:@"EmailId"];
        [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"UserID"] forKey:@"UserID"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"SendFriendRequest" append:@""forAction:@"POST"];
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
                                                                          [Utility msg:@"Friend request sent successfully" title:@"Success" controller:self haveToPop:NO];
                                                                          [self sendPushToUserWithEmail:email friendId:[responseDict[@"ShareChecklistId"] intValue]];
                                                                          self->sendEmailRequestView.hidden = true;
                                                                          [self.view endEditing:YES];
                                                                          
                                                                          return;
                                                                      }else{
                                                                          //[Utility msg:[responseDict objectForKey:@"ErrorMessage"] title:@"Error !" controller:self haveToPop:NO];
                                                                          return;
                                                                      }
                                                                  }else{
                                                                      [Utility msg:error.localizedDescription title:@"Error !" controller:self haveToPop:NO];
                                                                      return;
                                                                  }
                                                              });
                                                              
                                                          }];
        [dataTask resume];
        
    }else{
        [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
    }
    
}
-(void)findBuddyRequestExists_WebserviceCall{
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
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"FindBuddyRequestExists" append:@""forAction:@"POST"];
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
                                                                      NSLog(@"responseDict: \n %@",responseDict);
                                                                      if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"SuccessFlag"]boolValue]) {
                                                                          if ([[responseDict objectForKey:@"Exists"]boolValue]) {
                                                                              
                                                                              [self requestExistAlert];
                                                                              
                                                                          }else{
                                                                              AddYourselfBuddyViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AddYourselfBuddyView"];
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
#pragma mark - End

#pragma mark - Private Method
-(void)setupView{
    friendRequestButton.badgeFont = [UIFont fontWithName:@"Raleway-Medium" size:12];
    friendRequestButton.shouldHideBadgeAtZero = YES;
    
    for(UIView *view in borderViews){
        view.layer.borderColor = squadMainColor.CGColor;//[Utility colorWithHexString:@"E425A0"].CGColor;  //RU
        view.layer.borderWidth = 1.0;
    }
    
    emailRequestBodyView.layer.cornerRadius = 30;
    emailRequestBodyView.clipsToBounds = YES;
    
    emailTextField.layer.borderColor = squadMainColor.CGColor;//[Utility colorWithHexString:@"6E6E6E"].CGColor; //RU
    emailTextField.layer.borderWidth = 1.0;
    
    
    UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)]; //toolbar is uitoolbar object
    toolBar.barStyle = UIBarStyleBlackOpaque;
    toolBar.translucent = YES;
    UIBarButtonItem *btnDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(btnClickedDone:)];
    [toolBar setItems:[NSArray arrayWithObject:btnDone]];
    [emailTextField setInputAccessoryView:toolBar];
}
-(void)sendPushToUserWithEmail:(NSString *)email friendId:(int)friendShipId{
    /*
    if(![Utility isUserLoggedInToChatSdk]) return;
    
    NSString *firstName = (![Utility isEmptyCheck:[defaults objectForKey:@"FirstName"]])?[defaults objectForKey:@"FirstName"]:@"";
    
    NSString *msg = @"";
    
    if(![Utility isEmptyCheck:firstName]){
        msg = [@"" stringByAppendingFormat:@"%@ ,sent you a friend request. Click here to accept.",firstName];
    }else{
        msg = [@"" stringByAppendingFormat:@"You have a new friend request. Click here to accept."];
    }
    
    NSDictionary * dict = @{@"isFriendRequest": @YES,
                            @"friendShipId": [NSNumber numberWithInt:friendShipId],
                            bMessageTextKey:msg
                            };
    
    [Utility sendFriendRequestWithPush:email messageDetails:dict];
    */
}
-(void)requestExistAlert{
    
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"Alert!"
                                              message:@"You are already added to the buddy list. Would you like to search for a buddy?"
                                              preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:@"YES"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       SearchBuddyListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SearchBuddyListView"];
                                       [self.navigationController pushViewController:controller animated:YES];
                                       
                                   }];
        UIAlertAction *cancelAction = [UIAlertAction
                                       actionWithTitle:@"NO"
                                       style:UIAlertActionStyleCancel
                                       handler:^(UIAlertAction *action)
                                       {
                                           
                                       }];
        [alertController addAction:okAction];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
        
    
}
#pragma mark - End

#pragma mark-IBAction

- (IBAction)myBuddiesButtonPressed:(UIButton *)sender {
    MyBuddiesListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MyBuddiesListView"];
    controller.mybuddiesArr = accountabilityBuddiesArray;
    [self.navigationController pushViewController:controller animated:YES];
}
- (IBAction)friendRequestButtonPressed:(UIButton *)sender {
    
    BuddyRequestViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"BuddyRequest"];
    controller.modalPresentationStyle = UIModalPresentationCustom;
    controller.requestArray = requestArray;
    controller.delegate = self;
    [self presentViewController:controller animated:YES completion:nil];
}
- (IBAction)findMeABuddyButtonPressed:(UIButton *)sender {
    [self findBuddyRequestExists_WebserviceCall];
}
- (IBAction)searchBuddyListButtonPressed:(UIButton *)sender {
    SearchBuddyListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SearchBuddyListView"];
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)linkABuddiesEmailButtonPressed:(UIButton *)sender {
    emailTextField.text = @"";
    sendEmailRequestView.hidden = false;
}

- (IBAction)applyButtonPressed:(UIButton *)sender {
    NSString *email =emailTextField.text;
    if(![Utility isEmptyCheck:email]){
        if (![Utility validateEmail:email]) {
            [Utility msg:@"Please enter a valid email." title:@"Oops" controller:self haveToPop:NO];
            return;
        }else{
            [self sendFriendRequest:email];
        }
        
    }else{
        [Utility msg:@"Please enter friend's email." title:@"Oops" controller:self haveToPop:NO];
        return;
    }
}
- (IBAction)cancelEmailRequest:(UIButton *)sender {
    sendEmailRequestView.hidden = true;
    [self.view endEditing:YES];
}


#pragma mark-End

#pragma mark-Buddy Request Delegate
-(void)didDismiss{
    [self GetbuddyListApiCall];
}
#pragma mark-End
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
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    scroll.contentInset = contentInsets;
    scroll.scrollIndicatorInsets = contentInsets;
    
    
    if (activeTextField !=nil) {
        CGRect aRect = scroll.frame;
        aRect.size.height -= kbSize.height;
        if (!CGRectContainsPoint(aRect, activeTextField.frame.origin) ) {
            [scroll scrollRectToVisible:activeTextField.frame animated:YES];
        }
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    scroll.contentInset = contentInsets;
    scroll.scrollIndicatorInsets = contentInsets;
    
}
#pragma mark-End
#pragma mark - textField Delegate
-(void)btnClickedDone:(id)sender{
    [self.view endEditing:YES];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}
#pragma mark-End
@end
