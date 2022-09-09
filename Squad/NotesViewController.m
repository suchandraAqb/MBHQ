//
//  NotesViewController.m
//  Squad
//
//  Created by Suchandra Bhattacharya on 04/09/2019.
//  Copyright © 2019 AQB Solutions. All rights reserved.
//

#import "NotesViewController.h"
#import "GratitudeListViewController.h"
#import "GratitudePopUpViewController.h"
@interface NotesViewController ()
{
    IBOutlet UITextView *textview;
    IBOutlet UIScrollView *mainScroll;
    IBOutlet UIButton *saveButton;
    IBOutlet UILabel *growthLabel;
    IBOutlet UILabel *habitHackerQuestionLabel;
    IBOutlet NSLayoutConstraint *growLabelHeightConstant;
    IBOutlet NSLayoutConstraint *textViewHeightConstraint;
    IBOutlet UIButton *saveShareButton;
    IBOutlet UIView *showPicTypeView;
    IBOutlet UIView *seeExampleView;
    IBOutlet UIImageView *seeExampleImage;
    IBOutletCollection(UIButton) NSArray *buttonArr;
    UIToolbar *toolBar;
    UITextView *activeTextView;
    UITextField *activeTextField;
    CGSize kbSize;
    BOOL isOneTime;
    BOOL isTrueShare;
    NSDictionary *shareDict;
}
@end

@implementation NotesViewController
@synthesize notesDelegate;

#pragma mark - View Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    isTrueShare =false;
    saveButton.layer.cornerRadius = 15;
    saveButton.layer.masksToBounds = YES;
    saveShareButton.layer.cornerRadius = 15;
    saveShareButton.layer.masksToBounds = YES;
    if([Utility reachable] && ([_fromStr isEqualToString:@"Gratitude"] || [_fromStr isEqualToString:@"GratituteEdit"])){
        saveShareButton.hidden = false;
    }else{
        saveShareButton.hidden = true;
    }

    if ([_fromStr isEqualToString:@"Growth"] && ![Utility isEmptyCheck:_growthStr]) {
        growthLabel.text = [@"" stringByAppendingFormat:@"%@:",_growthStr];
        growthLabel.hidden = false;
        growLabelHeightConstant.constant = 40;
    }else if([_fromStr isEqualToString:@"GrowthEdit"] || ([_fromStr isEqualToString:@"GratituteEdit"])){
        textview.text = [@"" stringByAppendingFormat:@"%@",_growthStr];
    }else{
        growLabelHeightConstant.constant = 0;
        growthLabel.hidden = true;
    }
    for (UIButton *btn in buttonArr) {
           btn.layer.cornerRadius = 9;
           btn.layer.masksToBounds = YES;
       }
    toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    toolBar.barStyle = UIBarStyleBlackOpaque;
    toolBar.translucent = YES;
    UIBarButtonItem *btnDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(btnClickedDone:)];
    [toolBar setItems:[NSArray arrayWithObject:btnDone]];
    [textview becomeFirstResponder];
    
    if ([_fromStr isEqualToString:@"VisionStatement"] && ![Utility isEmptyCheck:_visionStatementText]) {
        textview.text=_visionStatementText;
    }
    
    if ([_fromStr isEqualToString:@"HabitDetails"]){
        if (![Utility isEmptyCheck:_habitText]) {
            textview.text=_habitText;
        }
        if (![Utility isEmptyCheck:_habitQuestionText]) {
            habitHackerQuestionLabel.hidden=false;
            habitHackerQuestionLabel.text=_habitQuestionText;
        }else{
            habitHackerQuestionLabel.hidden=true;
        }
    }
    [self registerForKeyboardNotifications];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    isOneTime = false;
    if([textview.text length]>0){
        NSLog(@"ContentSize:%f",textview.contentSize.height);
        textViewHeightConstraint.constant = textview.contentSize.height;
    }
}
#pragma mark - End

#pragma mark - Private Function

-(void)isTextChanged:(BOOL)value{
}
-(void)addUpdateDB:(NSDictionary*)dict{
    if (![Utility isSubscribedUser]){
        return;
    }
    NSString *detailsString = @"";
    
    if(![Utility isEmptyCheck:dict]){
        NSError *error;
        NSData *offlineData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            NSLog(@"Error Favorite Array-%@",error.debugDescription);
        }
        detailsString = [[NSString alloc] initWithData:offlineData encoding:NSUTF8StringEncoding];
    }
    
//    int userId = [[defaults valueForKey:@"UserID"] intValue];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *addedDateStr = [formatter stringFromDate:[NSDate date]];
    
    BOOL isAdd =  [DBQuery addGratitudeDetails:[[dict objectForKey:@"Id"]intValue] with:detailsString addedDate:addedDateStr isSync:0];
    if (isAdd) {
        NSString *msgStr = @"Your gratitude was saved.\nPlease note: Your 1st gratitude for the day will be visible on the today page in aeroplane mode. Extra gratitudes will be only visible once 'aeroplane' mode is turned off.";

        [self showMessageAlert:msgStr];
    }else{
        //[Utility msg:@"Data not inseted" title:@"" controller:self haveToPop:NO];
    }
}

-(void)addUpdateDBForGrowth:(NSDictionary*)dict{
    if (![Utility isSubscribedUser]){
        return;
    }
    NSString *detailsString = @"";
    
    if(![Utility isEmptyCheck:dict]){
        NSError *error;
        NSData *offlineData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            NSLog(@"Error Favorite Array-%@",error.debugDescription);
        }
        detailsString = [[NSString alloc] initWithData:offlineData encoding:NSUTF8StringEncoding];
    }
    
//    int userId = [[defaults valueForKey:@"UserID"] intValue];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *addedDateStr = [formatter stringFromDate:[NSDate date]];
    BOOL isAdd =  [DBQuery addGrowthDetails:[[dict objectForKey:@"Id"]intValue] with:detailsString addedDate:addedDateStr isSync:0];
    if (isAdd) {
        NSString *msgStr = @"Your growth was saved.\nPlease note:Your 1st growth for the day will be visible on the today page in aeroplane mode. Extra growth will be only visible once 'aeroplane' mode is turned off";

        [self showMessageAlert:msgStr];
    }else{
       // [Utility msg:@"Data not inseted" title:@"" controller:self haveToPop:NO];
    }
}
-(NSDictionary*)setUpGrowthDetails{
    NSMutableDictionary *achievementsData = [[NSMutableDictionary alloc]init];

          [achievementsData setObject:@"" forKey:@"Notes"];
          if (![Utility isEmptyCheck:_selectGrowth] && ![Utility isEmptyCheck:textview.text]) {
                [achievementsData setObject:[@"" stringByAppendingFormat:@"%@ : %@",_selectGrowth,textview.text] forKey:@"Achievement"];
          }
            if ([Utility isEmptyCheck:[achievementsData objectForKey:@"CategoryId"]] || [[achievementsData objectForKey:@"CategoryId"]intValue]==0) {
                [achievementsData setObject:[NSNumber numberWithInt:1] forKey:@"CategoryId"];
            }
          if ([achievementsData objectForKey:@"FrequencyId"] == nil) {
              [achievementsData setObject:[NSNumber numberWithInt:1] forKey:@"FrequencyId"];
              [achievementsData setObject:[NSNumber numberWithInt:1] forKey:@"MonthReminder"];
              [achievementsData setObject:[NSNumber numberWithInt:43200] forKey:@"ReminderAt1"];
              [achievementsData setObject:[NSNumber numberWithInt:43200] forKey:@"ReminderAt2"];
              [achievementsData setObject:[NSNumber numberWithInt:1] forKey:@"ReminderOption"];
              [achievementsData setObject:[NSNumber numberWithBool:false] forKey:@"PushNotification"];
              [achievementsData setObject:[NSNumber numberWithBool:false] forKey:@"Email"];
              
              NSDateFormatter *newDateformatter = [[NSDateFormatter alloc]init];
              NSArray* monthArray = [newDateformatter monthSymbols];
              NSArray* dayArray = [newDateformatter weekdaySymbols];
              for (int i = 0; i < monthArray.count; i++) {
                  [achievementsData setObject:[NSNumber numberWithBool:false] forKey:[monthArray objectAtIndex:i]];
              }
              for (int i = 0; i < dayArray.count; i++) {
                  [achievementsData setObject:[NSNumber numberWithBool:false] forKey:[dayArray objectAtIndex:i]];
              }
          }
          if (achievementsData[@"Id"] == nil) {
              [achievementsData setObject:[NSNumber numberWithInteger:0] forKey:@"Id"];
          }
          if (achievementsData[@"CreatedBy"] == nil) {
              [achievementsData setObject:[defaults valueForKey:@"UserID"] forKey:@"CreatedBy"];
          }
          [achievementsData setObject:@"" forKey:@"UploadPictureImgBase64"];
          
          if(![Utility isEmptyCheck:[defaults objectForKey:@"Date"]]){
              NSDateFormatter *format = [[NSDateFormatter alloc]init];
              [format setDateFormat:@"YYYY-MM-dd"];
              [achievementsData setObject:[format stringFromDate:[defaults objectForKey:@"Date"]] forKey:@"CreatedAtString"];
              
          }
    return [achievementsData mutableCopy];
}
-(NSDictionary*)setUpGratitudeDetails{
    NSMutableDictionary *gratitudeData = [[NSMutableDictionary alloc]init];
           
           [gratitudeData setObject:[@"" stringByAppendingFormat:@"%@",textview.text] forKey:@"Name"];//Today I am grateful for:
           [gratitudeData setObject:@"" forKey:@"Description"];//savehtmlTextForGratitude
           
           if ([gratitudeData objectForKey:@"FrequencyId"] == nil) {
               [gratitudeData setObject:[NSNumber numberWithInt:1] forKey:@"FrequencyId"];
               [gratitudeData setObject:[NSNumber numberWithInt:1] forKey:@"MonthReminder"];
               [gratitudeData setObject:[NSNumber numberWithInt:43200] forKey:@"ReminderAt1"];
               [gratitudeData setObject:[NSNumber numberWithInt:43200] forKey:@"ReminderAt2"];
               [gratitudeData setObject:[NSNumber numberWithInt:1] forKey:@"ReminderOption"];
               [gratitudeData setObject:[NSNumber numberWithBool:false] forKey:@"PushNotification"];
               [gratitudeData setObject:[NSNumber numberWithBool:false] forKey:@"Email"];
               
               NSDateFormatter *newDateformatter = [[NSDateFormatter alloc]init];
               NSArray* monthArray = [newDateformatter monthSymbols];
               NSArray* dayArray = [newDateformatter weekdaySymbols];
               for (int i = 0; i < monthArray.count; i++) {
                   [gratitudeData setObject:[NSNumber numberWithBool:false] forKey:[monthArray objectAtIndex:i]];
               }
               for (int i = 0; i < dayArray.count; i++) {
                   [gratitudeData setObject:[NSNumber numberWithBool:false] forKey:[dayArray objectAtIndex:i]];
               }
           }
           if (gratitudeData[@"Id"] == nil) {
               [gratitudeData setObject:[NSNumber numberWithInteger:0] forKey:@"Id"];
           }
           if (gratitudeData[@"CreatedBy"] == nil) {
               [gratitudeData setObject:[defaults valueForKey:@"UserID"] forKey:@"CreatedBy"];
           }
           
           [gratitudeData setObject:@"" forKey:@"UploadPictureImgBase64"];
           NSDateFormatter *format = [[NSDateFormatter alloc]init];
           [format setDateFormat:@"YYYY-MM-dd"];
           if (![Utility isEmptyCheck:[defaults objectForKey:@"Date"]]) {
               [gratitudeData setObject:[format stringFromDate:[defaults objectForKey:@"Date"]] forKey:@"CreatedAtString"];
           }
    return [gratitudeData mutableCopy];
}

-(void)showMessageAlert:(NSString*)message{

    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"SUCCESS\n"
                                          message:message
                                          preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:@"OK"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                  [[NSNotificationCenter defaultCenter]postNotificationName:@"backFromNotes" object:self userInfo:nil];
                                   [self.navigationController popToRootViewControllerAnimated:NO];
                               }];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
- (CGFloat)heightForString:(NSString *)text font:(UIFont *)font maxWidth:(CGFloat)maxWidth {
    if (![text isKindOfClass:[NSString class]] || !text.length) {
        // no text means no height
        return 0;
    }
    
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    NSDictionary *attributes = @{ NSFontAttributeName : font };
    CGSize size = [text boundingRectWithSize:CGSizeMake(maxWidth, CGFLOAT_MAX) options:options attributes:attributes context:nil].size;
    CGFloat height = ceilf(size.height) + 1; // add 1 point as padding
    
    return height;
}
#pragma mark - End

#pragma mark - IBAction
-(IBAction)saveButtonPressed:(id)sender{
    [self.view endEditing:YES];
    if (![Utility isEmptyCheck: textview.text]) {
        if ([_fromStr isEqualToString:@"Growth"]) {
              [self saveDataMultiPartForAccomplishment];
        }else if([_fromStr isEqualToString:@"Gratitude"]){
              [self saveDataMultiPart];
        }else if([_fromStr isEqualToString:@"BucketList"]){
            [self saveDataMultiPartForBucket];
        }else if([_fromStr isEqualToString:@"VisionStatement"]){
            [notesDelegate setStatementText:textview.text atIndex:_visionStatementIndex forKey:_visionStatementKey];
            [self backButtonPressed:0];
        }else if([_fromStr isEqualToString:@"HabitDetails"]){
            [notesDelegate setHabitText:textview.text textViewName:_textViewName];
            [self backButtonPressed:0];
        }else if ([_fromStr isEqualToString:@"GrowthEdit"]){
            NSArray *arr = [textview.text componentsSeparatedByString:@":"];
            if (arr.count>0) {
                _selectGrowth = [arr objectAtIndex:0];
                [notesDelegate saveButtonDetails:[@"" stringByAppendingFormat:@"%@",textview.text]];
                [self saveDataMultiPartForAccomplishment];
            }
        }else if ([_fromStr isEqualToString:@"GratituteEdit"]){
                [notesDelegate saveButtonDetails:[@"" stringByAppendingFormat:@"%@",textview.text]];
                [self saveDataMultiPart];
        }
        
    }else{
        [Utility msg:@"Please enter some text" title:@"" controller:self haveToPop:NO];
    }
  
}
-(IBAction)backButtonPressed:(id)sender{
    if (![Utility reachable]) {
        for (UIViewController *controller in self.navigationController.viewControllers) {
         if ([controller isKindOfClass:[TodayHomeViewController class]]) {
             [self.navigationController popToViewController:controller animated:YES];
             }
        }
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)saveDataMultiPartForBucket {
    NSMutableDictionary * bucketData = [[NSMutableDictionary alloc]init];
    
    if (Utility.reachable) {
        [bucketData setObject:textview.text forKey:@"Name"];
        [bucketData setObject:[NSNumber numberWithInt:1] forKey:@"CategoryId"];

//        if (![Utility isEmptyCheck:selectedCategoryDict]) {
//            [bucketData setObject:@"0" forKey:@"CategoryId"];
//
//        }else{
//            [Utility msg:@"Please Select Category " title:@"Error" controller:self haveToPop:NO];
//            return;
//        }
        if (![Utility isEmptyCheck:[defaults objectForKey:@"Date"]]) {
            NSDateFormatter *dateFormatter = [NSDateFormatter new];
            [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
            [dateFormatter setDateFormat:@"yyyy-MM-dd'T'hh:mm:ss"];
            NSDate *adding1YearDateFromCurrent = [[defaults objectForKey:@"Date"] dateByAddingYears:1];
            NSString *date = [dateFormatter stringFromDate:adding1YearDateFromCurrent];
            [bucketData setObject:date forKey:@"CompletionDate"];
        }
            [bucketData setObject:@"" forKey:@"Description"];
        
        if ([bucketData objectForKey:@"FrequencyId"] == nil) {
            [bucketData setObject:[NSNumber numberWithInt:1] forKey:@"FrequencyId"];
            [bucketData setObject:[NSNumber numberWithInt:1] forKey:@"MonthReminder"];
            [bucketData setObject:[NSNumber numberWithInt:43200] forKey:@"ReminderAt1"];
            [bucketData setObject:[NSNumber numberWithInt:43200] forKey:@"ReminderAt2"];
            [bucketData setObject:[NSNumber numberWithInt:1] forKey:@"ReminderOption"];
            [bucketData setObject:[NSNumber numberWithBool:false] forKey:@"PushNotification"];
            [bucketData setObject:[NSNumber numberWithBool:false] forKey:@"Email"];
            
            NSDateFormatter *newDateformatter = [[NSDateFormatter alloc]init];
            NSArray* monthArray = [newDateformatter monthSymbols];
            NSArray* dayArray = [newDateformatter weekdaySymbols];
            for (int i = 0; i < monthArray.count; i++) {
                [bucketData setObject:[NSNumber numberWithBool:false] forKey:[monthArray objectAtIndex:i]];
            }
            for (int i = 0; i < dayArray.count; i++) {
                [bucketData setObject:[NSNumber numberWithBool:false] forKey:[dayArray objectAtIndex:i]];
            }
        }
        if (bucketData[@"id"] == nil) {
            [bucketData setObject:[NSNumber numberWithInteger:0] forKey:@"id"];
        }

        if (bucketData[@"CreatedBy"] == nil) {
            [bucketData setObject:[defaults valueForKey:@"UserID"] forKey:@"CreatedBy"];
        }
        
        [bucketData setObject:@"" forKey:@"UploadPictureImgBase64"];
        
        NSError *error;
        
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:bucketData forKey:@"model"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        ProgressBarViewController *controller=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ProgressBar"];
        controller.delegate=self;
        controller.apiName=@"AddUpdateBucketApiCallWithPhoto";
        controller.appendString=@"";
        controller.jsonString=jsonString;
        controller.chosenImage=nil;
        controller.isFromtodayGetApiName = true;
        controller.modalPresentationStyle = UIModalPresentationCustom;
        [self presentViewController:controller animated:YES completion:nil];
    }else{
        [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
    }
    
}
-(void)saveDataMultiPart{
    if (Utility.reachable) {
        NSDictionary *gratitudedata;
        if ([_fromStr isEqualToString:@"GratituteEdit"]) {
            NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
            dict = [_addEditPageDict mutableCopy];
            [dict removeObjectForKey:@"Name"];
            [dict setObject:[@"" stringByAppendingFormat:@"%@",textview.text] forKey:@"Name"];
            gratitudedata = dict;
        }else{
            gratitudedata = [self setUpGratitudeDetails];
        }
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:gratitudedata forKey:@"model"];
        
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error){
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        NSLog(@"%@",jsonString);
        ProgressBarViewController *controller=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ProgressBar"];
        controller.delegate=self;
        controller.apiName=@"AddUpdateGratitudeApiCallWithPhoto";
        controller.appendString=@"";
        controller.jsonString=jsonString;
        controller.chosenImage=nil;
        controller.modalPresentationStyle = UIModalPresentationCustom;
        controller.isFromtodayGetApiName = true;
        [self presentViewController:controller animated:YES completion:nil];
    }else{
        NSDictionary *gratitudedata = [self setUpGratitudeDetails];
        [self addUpdateDB:gratitudedata];
        
    }
    
}
-(void)saveDataMultiPartForAccomplishment{
    if (Utility.reachable) {
        NSDictionary *achievementsData;
        if ([_fromStr isEqualToString:@"GrowthEdit"]) {
            NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
            dict = [_addEditPageDict mutableCopy];
            [dict removeObjectForKey:@"Achievement"];
            [dict setObject:[@"" stringByAppendingFormat:@"%@",textview.text] forKey:@"Achievement"];
            achievementsData = dict;
        }else{
            achievementsData = [self setUpGrowthDetails];
        }
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:achievementsData forKey:@"model"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        NSLog(@"%@",jsonString);
        ProgressBarViewController *controller=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ProgressBar"];
        controller.delegate=self;
        controller.apiName=@"AddUpdateReverseBucketApiCallWithPhoto";
        controller.appendString=@"";
        controller.jsonString=jsonString;
        controller.chosenImage=nil;
        controller.modalPresentationStyle = UIModalPresentationCustom;
        controller.isFromtodayGetApiName = true;
        [self presentViewController:controller animated:YES completion:nil];
    }else{
        NSDictionary *growthdata = [self setUpGrowthDetails];
        [self addUpdateDBForGrowth:growthdata];
    }
}

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
    kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
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
        aRect.size.height -= kbSize.height;
        if (!CGRectContainsPoint(aRect, activeTextField.frame.origin) ) {
            [mainScroll scrollRectToVisible:activeTextField.frame animated:YES];
        }

    }else if (activeTextView !=nil) {
        if (![Utility isEmptyCheck:activeTextView.text]) {

//            CGRect aRect = mainScroll.frame;
//            //CGRect frame = [mainScroll convertRect:activeTextView.frame fromView:activeTextView.superview];
//            aRect.origin.y -= kbSize.height;
//            if (!CGRectContainsPoint(aRect,activeTextView.frame.origin) ) {
//                CGRect newRect = activeTextView.frame;
//                newRect.size.height = newRect.size.height + 8;
//                [mainScroll scrollRectToVisible:newRect animated:YES];
//            }
            CGRect aRect = CGRectMake(activeTextView.frame.origin.x, activeTextView.frame.origin.y, activeTextView.contentSize.width, activeTextView.contentSize.height);
            aRect.size.height = aRect.size.height+8;
            [mainScroll scrollRectToVisible:aRect animated:YES];

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
-(IBAction)btnClickedDone:(id)sender{
    [self.view endEditing:YES];
     if([textview.text length]>0){
        NSLog(@"ContentSize:%f",textview.contentSize.height);
         CGFloat height = [[UIScreen mainScreen]bounds].size.height;
         textViewHeightConstraint.constant = height - (64+75+45+45);
    }
}
-(IBAction)saveShareBUttonPRessed:(id)sender{
    if (![Utility isEmptyCheck: textview.text]) {
        if ([textview.text isEqualToString:[_addEditPageDict objectForKey:@"Name"]]) {
            self->showPicTypeView.hidden = false;
            self->shareDict = _addEditPageDict;
        }else{
            isTrueShare = true;
            [self saveDataMultiPart];
        }
    }else{
        [Utility msg:@"Please write something that you want to share" title:@"" controller:self haveToPop:NO];
    }
}
-(IBAction)shareDetailsPressed:(UIButton*)sender{
    self->showPicTypeView.hidden = true;
    GratitudePopUpViewController *controller =  [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"GratitudePopUpView"];
                                            controller.modalPresentationStyle = UIModalPresentationCustom;
                                            controller.controller = self;
                                            controller.dict = shareDict;
                                            if (sender.tag == 0) {
                                                controller.type = @"TextWithPic";
                                            }else if(sender.tag == 1){
                                                controller.type = @"TextOverPic";
                                            }else{
                                                controller.type = @"";
                                            }
                                          [self presentViewController:controller animated:YES completion:nil];
}
-(IBAction)crossShareButtonPresssed:(id)sender{
    showPicTypeView.hidden = true;
}
-(IBAction)seeExamplePressed:(UIButton*)sender{
    seeExampleView.hidden = false;
    if (sender.tag == 0) {
        seeExampleImage.image = [UIImage imageNamed:@"textandpic.png"];
    }else if(sender.tag == 1){
        seeExampleImage.image = [UIImage imageNamed:@"textoverpic.png"];
    }else{
        seeExampleImage.image = [UIImage imageNamed:@"textonly.png"];
    }
}
-(IBAction)exampleCrossButtonPressed:(id)sender{
    seeExampleView.hidden = true;
}
#pragma mark - End
- (void)completedWithResponse:(NSString *)responseString responseDict:(NSDictionary *)responseDict from:(NSString *)fromApi{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"SuccessFlag"] boolValue]) {
//            [self addUpdateDB:responseDict];
            UIAlertController *alertController = [UIAlertController
                                                  alertControllerWithTitle:@"Success"
                                                  message:@"Saved Successfully."
                                                  preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction
                                       actionWithTitle:@"OK"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction *action)
                                       {
                                            [[NSNotificationCenter defaultCenter]postNotificationName:@"IsTodaypageReload" object:self userInfo:nil];       
                                           if ([self->notesDelegate respondsToSelector:@selector(reloadData:)]) {
                                               [self->notesDelegate reloadData:true];
                                           }
                                if ([fromApi isEqualToString:@"AddUpdateGratitudeApiCallWithPhoto"]) {
                                        NSArray *arr = [self.navigationController viewControllers];
                                        BOOL isControllerHave = false;
                                        [[NSNotificationCenter defaultCenter]postNotificationName:@"IsGratitudeListShow" object:self userInfo:nil];
                                    if (self->isTrueShare) {
                                        self->isTrueShare = false;
                                        self->showPicTypeView.hidden = false;
                                        self->shareDict = responseDict[@"Details"];
//                                        [Utility saveShareAlert:responseDict[@"Details"]with:self];
                                    }else{

                                        for (int i = 0 ; i<arr.count; i++) {
                                               if ([arr[i] isKindOfClass:[GratitudeListViewController class]]) {
                                                   isControllerHave =  true;
                                                   [self.navigationController popToViewController:arr[i] animated:NO];
                                               }
                                           }
                                        if (!isControllerHave) {
                                            GratitudeListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"GratitudeListView"];
                                            [self.navigationController pushViewController:controller animated:NO];
                                        }
                                    }
                                }else if([fromApi isEqualToString:@"AddUpdateReverseBucketApiCallWithPhoto"]){
                                    NSArray *arr = [self.navigationController viewControllers];
                                       BOOL isControllerHave = false;
                                    [[NSNotificationCenter defaultCenter]postNotificationName:@"IsGrowthListShow" object:self userInfo:nil];

                                       for (int i = 0 ; i<arr.count; i++) {
                                              if ([arr[i] isKindOfClass:[AchievementsViewController class]]) {
                                                  isControllerHave =  true;
                                                  [self.navigationController popToViewController:arr[i] animated:NO];
                                              }
                                          }
                                       if (!isControllerHave) {
                                           AchievementsViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"Achievements"];
                                           [self.navigationController pushViewController:controller animated:NO];
                                       }
                                }

                if ([fromApi isEqualToString:@"AddUpdateBucketApiCallWithPhoto"]) {
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"MoveToBucketEdit" object:self userInfo: [responseDict objectForKey:@"Details"]];
                }
                
            }];
            [alertController addAction:okAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }else{
            if ([fromApi isEqualToString:@"AddUpdateGratitudeApiCallWithPhoto"]) {
                  NSDictionary *gratitudedata = [self setUpGratitudeDetails];
                  [self addUpdateDB:gratitudedata];
            }else if([fromApi isEqualToString:@"AddUpdateReverseBucketApiCallWithPhoto"]){
                    NSDictionary *growthdata = [self setUpGrowthDetails];
                    [self addUpdateDBForGrowth:growthdata];
            }
//            [Utility msg:[responseDict objectForKey:@"ErrorMessage"] title:@"Error !" controller:self haveToPop:NO];
//            return;
        }
    });
}
- (void) completedWithError:(NSError *)error{
    [Utility msg:error.localizedDescription title:@"Error !" controller:self haveToPop:NO];
}

#pragma mark - textView Delegate

- (BOOL)textView:(UITextView *)txtView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
//   CGFloat maxHeight = 300;
//    if (textViewHeightConstraint.constant < maxHeight) {
//        textViewHeightConstraint.constant +=15;
//        [self.view setNeedsUpdateConstraints];
//    }
    
    return YES;
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    activeTextView = textView;
    [textView setInputAccessoryView:toolBar];
    
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    
    activeTextView = textView;
    activeTextField = nil;
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    activeTextView = nil;
    NSLog(@"%@",textView.text);
}



@end
