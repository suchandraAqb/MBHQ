//
//  AddYourselfBuddyViewController.m
//  Squad
//
//  Created by AQB Solutions Private Limited on 03/11/18.
//  Copyright © 2018 AQB Solutions. All rights reserved.
//

#import "AddYourselfBuddyViewController.h"

@interface AddYourselfBuddyViewController (){
    
    __weak IBOutlet UIScrollView *mainScroll;
    __weak IBOutlet UITextField *firstNameTextField;
    __weak IBOutlet UITextField *lastNameTextField;
    __weak IBOutlet UITextView *messageViewTextField;
    __weak IBOutlet UIButton *timezoneButton;
    __weak IBOutlet UIButton *countryButton;
    __weak IBOutlet UIButton *stateButton;
    __weak IBOutlet UIButton *cityButton;
    __weak IBOutlet UIImageView *imagePreview;
    IBOutletCollection(UIView) NSArray *borderVIews;
    IBOutlet UIView *stateContainer;
    IBOutlet UIView *cityContainer;
    UILabel *textViewPlaceHolderLabel;
    
    UITextField *activeTextField;
    UITextView *activeTextView;
    UIView *contentView;
    UIToolbar *toolBar;
    UIImage *selectedImage;
    int apiCount;
    NSArray *countryArray;
    NSArray *stateArray;
    NSArray *cityArray;
    NSArray *timezoneArray;
    NSDictionary *selectedCountry;
    NSString *selectedState;
    NSDictionary *selectedCity;
    NSDictionary *savedCountryCity;
    NSString *timezone;
    
}

@end

@implementation AddYourselfBuddyViewController
#pragma mark-View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString *filePath;
    NSError *error;
    
    filePath = [[NSBundle mainBundle] pathForResource:@"Timezone" ofType:@"json"];
    
    NSData *jsonData = [NSData dataWithContentsOfFile:filePath];
    timezoneArray = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
    
    if(error){
        NSLog(@"Signup Notification JSON Read Error:%@",error.debugDescription);
        return;
    }

    toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    toolBar.barStyle = UIBarStyleBlackOpaque;
    toolBar.translucent = YES;
    UIBarButtonItem *keyBoardDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(keyBoardDoneButtonClicked)];
    [toolBar setItems:[NSArray arrayWithObject:keyBoardDone]];
    apiCount = 0;
    savedCountryCity=[defaults dictionaryForKey:@"UserCountryCity"];
    [self getCountry];
    [self registerForKeyboardNotifications];
    [self setupView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark-End
#pragma mark-Private Method
-(void)setupView{
    
    if(!textViewPlaceHolderLabel){
        textViewPlaceHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.0, 10.0,messageViewTextField.frame.size.width, 34.0)];
        textViewPlaceHolderLabel.textAlignment = NSTextAlignmentLeft;
        textViewPlaceHolderLabel.textColor = [UIColor lightGrayColor];
        textViewPlaceHolderLabel.font = [UIFont fontWithName:@"Oswald-Light" size:16.0];
        
    }
    
    [textViewPlaceHolderLabel setText:@"Start Typing"];
    [textViewPlaceHolderLabel setBackgroundColor:[UIColor clearColor]];
    [textViewPlaceHolderLabel setTextColor:[UIColor lightGrayColor]];
    [messageViewTextField addSubview:textViewPlaceHolderLabel];
    for(UIView *view in borderVIews){
        view.layer.borderColor = [UIColor lightGrayColor].CGColor;
        view.layer.borderWidth = 1.0;
    }
    
    [timezoneButton setTitle:@"--Select Timezone--" forState:UIControlStateNormal];
    [countryButton setTitle:@"--Select Country--" forState:UIControlStateNormal];
    [stateButton setTitle:@"--Select State--" forState:UIControlStateNormal];
    [cityButton setTitle:@"--Select City--" forState:UIControlStateNormal];
}
- (void)openEditor
{
    PECropViewController *controller = [[PECropViewController alloc] init];
    controller.delegate = self;
    controller.image = selectedImage;
    controller.keepingCropAspectRatio = YES;
    controller.cropAspectRatio = 1.0;
    
    //        UIImage *image = selectedImage;
    //        CGFloat width = image.size.width;
    //        CGFloat height = image.size.height;
    //        CGFloat length = MIN(width, height);
    //        controller.imageCropRect = CGRectMake((width - length) / 2,
    //                                              (height - length) / 2,
    //                                              length/2,
    //                                              length);
    
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
    }
    
    [self presentViewController:navigationController animated:YES completion:NULL];
}
-(void)openPhotoAlbum{
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    controller.delegate = self;
    controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:controller animated:YES completion:NULL];
}
-(void)showCamera{
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]){
        controller.delegate = self;
        controller.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:controller animated:YES completion:NULL];
    }else{
        [Utility msg:@"Camera Not Available." title:@"Warning !" controller:self haveToPop:NO];
    }
    
}
-(void)getCountry{
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(),^ {
            self->apiCount++;
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
            self->contentView = [Utility activityIndicatorView:self];
        });
        NSURLSession *dailySession = [NSURLSession sharedSession];
        NSMutableURLRequest *request = [Utility getRequest:@"" api:@"GetSquadCountriesApiCall" append:@"" forAction:@"GET"];
        NSURLSessionDataTask * dataTask =[dailySession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(),^ {
                                                                 self->apiCount--;
                                                                 if (self->apiCount == 0 && self->contentView) {
                                                                     [self->contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSArray *responseArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseArray] && responseArray.count > 0) {
                                                                         NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"CountryName"  ascending:YES];
                                                                         self->countryArray=[responseArray sortedArrayUsingDescriptors:[NSArray arrayWithObjects:descriptor,nil]];
                                                                         self->countryArray = [self deleteBlankElement:self->countryArray type:@"CountryID"];
                                                                         if (![Utility isEmptyCheck:self->savedCountryCity] && ![Utility isEmptyCheck:self->countryArray]) {
                                                                             NSDictionary *tempSelectedCountry = [Utility getDictByValue:self->countryArray value:self->savedCountryCity[@"CountryId"] type:@"CountryID"];
                                                                             if (![Utility isEmptyCheck:tempSelectedCountry] && tempSelectedCountry[@"CountryID"] != [NSNumber numberWithInteger:-1]) {
                                                                                 self->selectedCountry =tempSelectedCountry;
                                                                                 [self->countryButton setTitle:[self->selectedCountry objectForKey:@"CountryName"] forState:UIControlStateNormal];
                                                                                 [self getState];
                                                                                 
                                                                             }else{
                                                                                 self->selectedCountry = nil;
                                                                             }
                                                                         }else{
                                                                             self->selectedCountry = nil;
                                                                         }
                                                                         
                                                                         self->countryButton.enabled = true;
                                                                     }else{
                                                                         self->countryButton.enabled = false;
                                                                         
                                                                         [Utility msg:@"Something Went Wrong.Please Try Later." title:@"Error !" controller:self haveToPop:NO];
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
-(void)getState{
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(),^ {
            self->apiCount++;
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
            self->contentView = [Utility activityIndicatorView:self];
        });
        NSString *appendingString = @"";
        if (![Utility isEmptyCheck:self->selectedCountry]) {
            appendingString =[NSString stringWithFormat:@"?countryId=%@",selectedCountry[@"CountryID"]];
        }else{
            [Utility msg:@"Please select Country." title:@"Oops! " controller:self haveToPop:NO];
            return;
        }
        NSURLSession *dailySession = [NSURLSession sharedSession];
        NSMutableURLRequest *request = [Utility getRequest:@"" api:@"GetSquadStatesApiCall" append:appendingString forAction:@"GET"];
        NSURLSessionDataTask * dataTask =[dailySession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(),^ {
                                                                 self->apiCount--;
                                                                 if (self->apiCount == 0 && self->contentView) {
                                                                     [self->contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSArray *responseArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if ([responseArray isKindOfClass:NSArray.class]&&![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseArray] && responseArray.count > 0) {
                                                                         self->stateArray = [responseArray sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
                                                                         self->stateContainer.hidden= false;
                                                                         self->cityContainer.hidden = true;
                                                                         
                                                                     }else{
                                                                         self->stateContainer.hidden= true;
                                                                         self->cityContainer.hidden = true;
                                                                         
                                                                         [self getCity];
                                                                         //[Utility msg:@"Something Went Wrong.Please Try Later." title:@"Error !" controller:self haveToPop:NO];
                                                                         //return;
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

-(void)getCity{
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(),^ {
            self->apiCount++;
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
            self->contentView = [Utility activityIndicatorView:self];
        });
        NSString *appendingString = @"";
        if (![Utility isEmptyCheck:selectedCountry]) {
            appendingString =[NSString stringWithFormat:@"?countryId=%@&state=%@",selectedCountry[@"CountryID"],![Utility isEmptyCheck:selectedState] ?selectedState : @""];
        }else{
            [Utility msg:@"Please select Country & State." title:@"Oops! " controller:self haveToPop:NO];
            return;
        }
        NSURLSession *dailySession = [NSURLSession sharedSession];
        NSMutableURLRequest *request = [Utility getRequest:@"" api:@"GetSquadCitiesApiCall" append:appendingString forAction:@"GET"];
        NSURLSessionDataTask * dataTask =[dailySession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(),^ {
                                                                 self->apiCount--;
                                                                 if (self->apiCount == 0 && self->contentView) {
                                                                     [self->contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSArray *responseArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if ([responseArray isKindOfClass:NSArray.class]&&![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseArray] && responseArray.count > 0) {
                                                                         NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"SquadCityName"  ascending:YES];
                                                                         self->cityArray=[responseArray sortedArrayUsingDescriptors:[NSArray arrayWithObjects:descriptor,nil]];
                                                                         [self deleteBlankElement:self->cityArray type:@"SquadCityId"];
                                                                         self->cityContainer.hidden= false;
                                                                         if (![Utility isEmptyCheck:self->savedCountryCity] && ![Utility isEmptyCheck:self->cityArray]) {
                                                                             NSDictionary *tempSelectedCity = [Utility getDictByValue:self->cityArray value:self->savedCountryCity[@"CityId"] type:@"SquadCityId"];
                                                                             if (![Utility isEmptyCheck:tempSelectedCity]) {
                                                                                 self->selectedCity =tempSelectedCity;
                                                                                 [self->cityButton setTitle:[self->selectedCity objectForKey:@"SquadCityName"] forState:UIControlStateNormal];
                                                                                 
                                                                                 
                                                                             }else{
                                                                                 self->selectedCity = nil;
                                                                             }
                                                                         }else{
                                                                             self->selectedCity = nil;
                                                                         }
                                                                     }else{
                                                                         self->cityContainer.hidden = true;
                                                                         
                                                                         [Utility msg:@"Something Went Wrong.Please Try Later." title:@"Error !" controller:self haveToPop:NO];
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
-(NSArray *)deleteBlankElement:(NSArray *)dataArra type:(NSString *)type{
    NSMutableArray *tempArray =dataArra.mutableCopy;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(%K == %@)",type, [NSNumber numberWithInteger:-1]];
    NSArray *filteredSessionCategoryArray = [tempArray filteredArrayUsingPredicate:predicate];
    if (filteredSessionCategoryArray.count > 0) {
        for (NSDictionary *dict in filteredSessionCategoryArray) {
            [tempArray removeObject:dict];
        }
    }
    return tempArray;
    
}
-(BOOL)formValidation{
    BOOL isValidated =  true;
    
    if ([Utility isEmptyCheck:firstNameTextField.text]){
        
        [Utility msg:@"Please enter First Name." title:@"" controller:self haveToPop:false];
        isValidated = false;
    }else if ([Utility isEmptyCheck:lastNameTextField.text]){
        
        [Utility msg:@"Please enter Last Letter of Last Name." title:@"" controller:self haveToPop:false];
        isValidated = false;
    }else if ([Utility isEmptyCheck:messageViewTextField.text]){
        
        [Utility msg:@"Please enter your message." title:@"" controller:self haveToPop:false];
        isValidated = false;
    }else if ([Utility isEmptyCheck:selectedCountry]){
        
        [Utility msg:@"Please selct your country." title:@"" controller:self haveToPop:false];
        isValidated = false;
    }
    
    return isValidated;
}
#pragma mark-End
#pragma mark-WebService Call
-(void)addUpdateFindBuddyRequestWithPhoto{
    
    if (Utility.reachable) {
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"UserID"] forKey:@"UserID"];
        
        NSMutableDictionary *modelDict = [NSMutableDictionary new];
        [modelDict setObject:[defaults objectForKey:@"UserID"] forKey:@"UserId"];
        [modelDict setObject:[NSNumber numberWithInt:0] forKey:@"FindBuddyRequestId"];
        [modelDict setObject:[NSNumber numberWithBool:1] forKey:@"IsActive"];
        [modelDict setObject:[NSNumber numberWithBool:0] forKey:@"IsDeleted"];
        [modelDict setObject:[@"" stringByAppendingFormat:@"%@",messageViewTextField.text] forKey:@"Message"];
        
        NSMutableDictionary *userDict = [NSMutableDictionary new];
        [userDict setObject:[defaults objectForKey:@"UserID"] forKey:@"UserId"];
        [userDict setObject:[@"" stringByAppendingFormat:@"%@",firstNameTextField.text] forKey:@"FirstName"];
        [userDict setObject:[@"" stringByAppendingFormat:@"%@",lastNameTextField.text] forKey:@"LastName"];
        if(![Utility isEmptyCheck:timezone]){
           [userDict setObject:[@"" stringByAppendingFormat:@"%@",timezone] forKey:@"Timezone"];
        }
        
        if(![Utility isEmptyCheck:selectedCountry[@"CountryName"]]){
            [userDict setObject:[@"" stringByAppendingFormat:@"%@",selectedCountry[@"CountryName"]] forKey:@"Country"];
        }
        
        if(![Utility isEmptyCheck:selectedState]){
            [userDict setObject:[@"" stringByAppendingFormat:@"%@",selectedState] forKey:@"State"];
        }
        
        if(![Utility isEmptyCheck:selectedCity[@"SquadCityName"]]){
            [userDict setObject:[@"" stringByAppendingFormat:@"%@",selectedCity[@"SquadCityName"]] forKey:@"City"];
        }
        
        
        [modelDict setObject:userDict forKey:@"UserDetail"];
        [mainDict setObject:modelDict forKey:@"Model"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        ProgressBarViewController *controller=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ProgressBar"];
        controller.delegate=self;
        controller.apiName=@"AddUpdateFindBuddyRequestWithPhoto";
        controller.appendString=@"";
        controller.jsonString=jsonString;
        controller.chosenImage=selectedImage;
        controller.modalPresentationStyle = UIModalPresentationCustom;
        [self presentViewController:controller animated:YES completion:nil];
        
    }else{
        [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
    }
}
#pragma mark-End
#pragma mark-IBAction

- (IBAction)timezoneButtonPressed:(UIButton *)sender {
    PopoverSettingsViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PopoverSettingsView"];
    controller.modalPresentationStyle = UIModalPresentationCustom;
    controller.tableDataArray = timezoneArray;
    controller.sender = sender;
    controller.delegate = self;
    controller.selectedIndex = -1;
    [self presentViewController:controller animated:YES completion:nil];
}

- (IBAction)countryButtonPressed:(UIButton *)sender {
    if (![Utility isEmptyCheck:countryArray]) {
        DropdownViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Dropdown"];
        controller.modalPresentationStyle = UIModalPresentationCustom;
        controller.dropdownDataArray = countryArray;
        controller.mainKey = @"CountryName";
        controller.apiType = @"Country";
        if (![Utility isEmptyCheck:selectedCountry]) {
            controller.selectedIndex = (int)[countryArray indexOfObject:selectedCountry];
        }else{
            controller.selectedIndex = -1;
        }
        controller.delegate = self;
        controller.sender = sender;
        [self presentViewController:controller animated:YES completion:nil];
    }else{
        [Utility msg:@"Something Went Wrong.Please Try Later." title:@"Error !" controller:self haveToPop:NO];
        return;
    }
}
- (IBAction)stateButtonPressed:(UIButton *)sender {
    
    if([Utility isEmptyCheck:selectedCountry]){
        [Utility msg:@"Please select country." title:@"Error !" controller:self haveToPop:NO];
        return;
    }
    
    
    if (![Utility isEmptyCheck:stateArray]) {
        DropdownViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Dropdown"];
        controller.modalPresentationStyle = UIModalPresentationCustom;
        controller.dropdownDataArray = stateArray;
        controller.apiType = @"State";
        if (![Utility isEmptyCheck:selectedState]) {
            controller.selectedIndex = (int)[stateArray indexOfObject:selectedState];
        }else{
            controller.selectedIndex = -1;
        }
        controller.delegate = self;
        controller.sender = sender;
        [self presentViewController:controller animated:YES completion:nil];
        
    }else{
        [Utility msg:@"Something Went Wrong.Please Try Later." title:@"Error !" controller:self haveToPop:NO];
        return;
    }
}
- (IBAction)cityButtonPressed:(UIButton *)sender {
    
    if([Utility isEmptyCheck:selectedCountry]){
        [Utility msg:@"Please select country." title:@"Error !" controller:self haveToPop:NO];
        return;
    }else if(!stateContainer.isHidden && [Utility isEmptyCheck:selectedCountry]){
        [Utility msg:@"Please select state." title:@"Error !" controller:self haveToPop:NO];
        return;
    }
    
    if (![Utility isEmptyCheck:cityArray]) {
        DropdownViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Dropdown"];
        controller.modalPresentationStyle = UIModalPresentationCustom;
        controller.dropdownDataArray = cityArray;
        controller.mainKey = @"SquadCityName";
        controller.apiType = @"City";
        if (![Utility isEmptyCheck:selectedCity]) {
            controller.selectedIndex = (int)[cityArray indexOfObject:selectedCity];
        }else{
            controller.selectedIndex = -1;
        }
        controller.delegate = self;
        controller.sender = sender;
        [self presentViewController:controller animated:YES completion:nil];
    }else{
        [Utility msg:@"Something Went Wrong.Please Try Later." title:@"Error !" controller:self haveToPop:NO];
        return;
    }
}
- (IBAction)captureImageButtonPressed:(UIButton *)sender {
    UIAlertController* alert = [UIAlertController
                                alertControllerWithTitle:nil      //  Must be "nil", otherwise a blank title area will appear above our two buttons
                                message:@"Select an Option"
                                preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* button0 = [UIAlertAction
                              actionWithTitle:@"Cancel"
                              style:UIAlertActionStyleCancel
                              handler:^(UIAlertAction * action)
                              {
                                  //  UIAlertController will automatically dismiss the view
                              }];
    
    UIAlertAction* button1 = [UIAlertAction
                              actionWithTitle:@"Take photo"
                              style:UIAlertActionStyleDefault
                              handler:^(UIAlertAction * action)
                              {
                                  [self showCamera];
                              }];
    
    UIAlertAction* button2 = [UIAlertAction
                              actionWithTitle:@"Open Gallery"
                              style:UIAlertActionStyleDefault
                              handler:^(UIAlertAction * action)
                              {
                                  [self openPhotoAlbum];
                              }];
    
    [alert addAction:button0];
    [alert addAction:button1];
    [alert addAction:button2];
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)skipButtonPressed:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)submitButtonPressed:(UIButton *)sender {
    
    if([self formValidation]){
        [self addUpdateFindBuddyRequestWithPhoto];
    }
}

#pragma mark-End
#pragma mark - KeyboardNotifications -
- (void)keyBoardDoneButtonClicked{
    [self.view endEditing:YES];
}
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

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    activeTextField = textField;
    [activeTextField setInputAccessoryView:toolBar];
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self.view endEditing:YES];
    activeTextField = nil;
}
#pragma mark - End
#pragma mark - TextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    activeTextView = textView;
    [textView setInputAccessoryView:toolBar];
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    
    [textView resignFirstResponder];
    activeTextView = nil;
}
- (void)textViewDidBeginEditing:(UITextView *)textView{
    if (![textView hasText]) {
        textViewPlaceHolderLabel.hidden = NO;
    }
}

- (void) textViewDidChange:(UITextView *)textView
{
    if(![textView hasText]) {
        textViewPlaceHolderLabel.hidden = NO;
    }
    else{
        textViewPlaceHolderLabel.hidden = YES;
    }
}
#pragma mark - End
#pragma mark - UIImagePickerControllerDelegate methods

/*
 Open PECropViewController automattically when image selected.
 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    image =[Utility scaleImage:image width:image.size.width height:image.size.height];
    imagePreview.image = image;
    selectedImage=image;
    
    [picker dismissViewControllerAnimated:YES completion:^{
        [self openEditor];
    }];
}
#pragma mark - End
#pragma mark - PECropViewControllerDelegate methods

- (void)cropViewController:(PECropViewController *)controller didFinishCroppingImage:(UIImage *)croppedImage transform:(CGAffineTransform)transform cropRect:(CGRect)cropRect
{
    [controller dismissViewControllerAnimated:YES completion:NULL];
    
    imagePreview.image = croppedImage;
    selectedImage = croppedImage;
    
    
}

- (void)cropViewControllerDidCancel:(PECropViewController *)controller
{
    
    [controller dismissViewControllerAnimated:YES completion:NULL];
}
#pragma mark - End
#pragma mark -DropdownViewDelegate
-(void)dropdownSelected:(NSString *)selectedValue sender:(UIButton *)sender type:(NSString *)type{
    if ([type caseInsensitiveCompare:@"State"] == NSOrderedSame) {
        selectedCity = nil;
        cityContainer.hidden = true;
        [sender setTitle:selectedValue forState:UIControlStateNormal];
        [cityButton setTitle:@"" forState:UIControlStateNormal];
        selectedState = selectedValue;
        [self getCity];
        
    }
}
- (void) didSelectAnyDropdownOption:(NSString *)type data:(NSDictionary *)selectedData sender:(UIButton *)sender{
    if ([type caseInsensitiveCompare:@"Country"] == NSOrderedSame) {
        selectedState = nil;
        selectedCity = nil;
        
        stateContainer.hidden = true;
        cityContainer.hidden = true;
        [sender setTitle:[selectedData objectForKey:@"CountryName"] forState:UIControlStateNormal];
        [stateButton setTitle:@"" forState:UIControlStateNormal];
        [cityButton setTitle:@"" forState:UIControlStateNormal];
        selectedCountry = selectedData;
        [self getState];
    }else if ([type caseInsensitiveCompare:@"City"] == NSOrderedSame) {
        
        [sender setTitle:[selectedData objectForKey:@"SquadCityName"] forState:UIControlStateNormal];
        selectedCity = selectedData;
        
    }
}
#pragma mark End
#pragma mark - PopoverViewDelegate
- (void) didSelectAnyOptionWithSender:(UIButton *)sender index:(int)index{
    if (timezoneArray.count > 0) {
        NSDictionary *zone = [timezoneArray objectAtIndex:index];
        if (![Utility isEmptyCheck:zone]) {
            [timezoneButton setTitle:[zone objectForKey:@"Value"] forState:UIControlStateNormal];
            timezone = [zone objectForKey:@"Value"];
            
        }
    }
}
#pragma mark End
#pragma mark progressbar delegate

- (void) completedWithResponse:(NSString *)responseString responseDict:(NSDictionary *)responseDict{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"SuccessFlag"] boolValue]) {
            [Utility msg:@"Successfully Added" title:@"Success" controller:self haveToPop:YES];
        }
        else{
            [Utility msg:[responseDict objectForKey:@"ErrorMessage"] title:@"Error !" controller:self haveToPop:NO];
            return;
        }
    });
}


- (void) completedWithError:(NSError *)error{
    
    [Utility msg:error.localizedDescription title:@"Error !" controller:self haveToPop:NO];
}



#pragma Mark End


@end
