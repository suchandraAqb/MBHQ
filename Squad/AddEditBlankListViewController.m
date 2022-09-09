//
//  AddEditBlankListViewController.m
//  Squad
//
//  Created by AQB Mac 4 on 03/05/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import "AddEditBlankListViewController.h"

@interface AddEditBlankListViewController (){
    IBOutlet UIScrollView *mainScroll;
    IBOutlet UIButton *dateButton;
    IBOutlet UITextView *descriptionTextView;
    IBOutlet UIButton *saveButton;
    IBOutlet UIButton *cancelButton;
    IBOutlet UILabel *titleLabel;
    IBOutlet UIView *contentView;


    UITextView *activeTextView;
    UIToolbar *toolBar;
    NSDate *selectedDate;
    UIView *activityContentView;
    int apiCount;

}

@end

@implementation AddEditBlankListViewController
@synthesize blankData,delegate;
#pragma mark - PrivateMethod
-(void)addEditBlankList{
    if (Utility.reachable) {
        
        NSURLSession *dailySession = [NSURLSession sharedSession];
        NSError *error;
        NSString *api = @"";
        NSString *msg =@"";
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults objectForKey:@"UserID"] forKey:@"UserID"];
        [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        if (![Utility isEmptyCheck:blankData]) {
            [mainDict setObject:[blankData objectForKey:@"Id"] forKey:@"Id"];
            api=@"EditCheckListApiCall";
            msg=@"CheckList Edited Sucessfully";
        }else{
            api=@"AddSquadCheckListApiCall";
            msg=@"CheckList Added Sucessfully";
        }
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
        if (selectedDate && ![Utility isEmptyCheck:selectedDate]) {
            [mainDict setObject:[formatter stringFromDate:selectedDate] forKey:@"ChecklistDate"];
        }else{
            [Utility msg:@"Please select CheckList date" title:@"Warning." controller:self haveToPop:YES];
            return;
        }
        
        if (![Utility isEmptyCheck:descriptionTextView.text] && descriptionTextView.text.length >0) {
            [mainDict setObject:descriptionTextView.text forKey:@"Description"];
        }else{
            [Utility msg:@"Description cannot be blank." title:@"Warning." controller:self haveToPop:YES];
            return;
        }

        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        
        dispatch_async(dispatch_get_main_queue(),^ {
            apiCount++;
            if (activityContentView) {
                [activityContentView removeFromSuperview];
            }
            activityContentView = [Utility activityIndicatorView:self];
        });
        
        
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:api append:@"" forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[dailySession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(),^ {
                                                                 apiCount--;
                                                                 if (apiCount == 0 && contentView) {
                                                                     [activityContentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     
                                                                     NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDictionary]) {
                                                                         if (![[responseDictionary objectForKey:@"Success"] boolValue]) {
                                                                             [Utility msg:[responseDictionary objectForKey:@"ErrorMessage"] title:@"Error!" controller:self haveToPop:NO];
                                                                         } else {
                                                                             [self dismissViewControllerAnimated:YES completion:^{
                                                                                 [Utility msg:msg title:@"Success" controller:self haveToPop:NO];
                                                                                 [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateBadgePoint" object:self];//gami_badge_popup_nourish

                                                                                 if([delegate respondsToSelector:@selector(didDismiss)]){
                                                                                     [delegate didDismiss];
                                                                                 }
                                                                             }];
                                                                         }
                                                                     }else{
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
#pragma mark - End
#pragma mark - IBAction
-(IBAction)dateButtonPressed:(id)sender{
    [self.view endEditing:true];
    DatePickerViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DatePicker"];
    controller.modalPresentationStyle = UIModalPresentationCustom;
    controller.maxDate = [NSDate date];
    NSTimeInterval sixmonth = -6*30*24*60*60;
    controller.minDate = [[NSDate date]
                          dateByAddingTimeInterval:sixmonth];
    controller.selectedDate = selectedDate;
    controller.datePickerMode = UIDatePickerModeDate;
    controller.delegate = self;
    [self presentViewController:controller animated:YES completion:nil];
}
-(IBAction)saveButtonPressed:(id)sender{
    [self.view endEditing:true];
    [self addEditBlankList];
}
-(IBAction)cancelButtonPressed:(id)sender{
    [self.view endEditing:true];
    [self dismissViewControllerAnimated:YES completion:^{
        if([delegate respondsToSelector:@selector(didDismiss)]){
            [delegate didDismiss];
        }
    }];

}
-(IBAction)keyBoardDoneButtonClicked:(id)sender{
    [self.view endEditing:true];
}
#pragma mark - End

#pragma mark - ViewLife Cycle
- (void)viewDidLoad{
    [super viewDidLoad];
    apiCount=0;
    contentView.layer.cornerRadius = 5.0;
    contentView.layer.masksToBounds = YES;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    selectedDate = [NSDate date];
    if (![Utility isEmptyCheck:blankData]) {
        NSDate *date = [formatter dateFromString:blankData[@"Date"]];
        if (date) {
            selectedDate = date;
        }
        descriptionTextView.text = ![Utility isEmptyCheck:blankData[@"Description"]]? blankData[@"Description"]:@"";
    }
    [formatter setDateFormat:@"dd-MMM-yyyy"];
    [dateButton setTitle:[formatter stringFromDate:selectedDate] forState:UIControlStateNormal];

    toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    toolBar.barStyle = UIBarStyleBlackOpaque;
    toolBar.translucent = YES;
    UIBarButtonItem *keyBoardDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(keyBoardDoneButtonClicked:)];
    [toolBar setItems:[NSArray arrayWithObject:keyBoardDone]];
    [self registerForKeyboardNotifications];
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
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    mainScroll.contentInset = contentInsets;
    mainScroll.scrollIndicatorInsets = contentInsets;
    if (activeTextView !=nil) {
        CGRect aRect = mainScroll.frame;
        CGRect frame = [mainScroll convertRect:activeTextView.frame fromView:activeTextView.superview];
        aRect.size.height -= kbSize.height;
        CGPoint tempPoint = CGPointMake(frame.origin.x, frame.origin.y+frame.size.height);
        if (!CGRectContainsPoint(aRect,tempPoint) ) {
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
#pragma mark - End
#pragma mark - textView Delegate
- (void)textViewDidChange:(UITextView *)textView {
    
}
- (BOOL)textView:(UITextView *)txtView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    return YES;
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    [textView setInputAccessoryView:toolBar];
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    activeTextView = textView;
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    activeTextView = nil;
}


#pragma mark - End
#pragma  mark -DatePickerViewControllerDelegate
-(void)didSelectDate:(NSDate *)date{
    NSLog(@"%@\n%@",date,[defaults objectForKey:@"Timezone"]);
    if (date) {
        static NSDateFormatter *dateFormatter;
        dateFormatter = [NSDateFormatter new];
        
        //[dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:[defaults objectForKey:@"Timezone"]]];
        [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
        selectedDate = date;
        [dateFormatter setDateFormat:@"dd-MMM-yyyy"];
        NSString *dateString = [dateFormatter stringFromDate:date];
        [dateButton setTitle:dateString forState:UIControlStateNormal];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
