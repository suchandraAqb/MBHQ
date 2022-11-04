//
//  SquadInfoViewController.m
//  Squad
//
//  Created by AQB Solutions Private Limited on 28/05/18.
//  Copyright © 2018 AQB Solutions. All rights reserved.
//

#import "SquadInfoViewController.h"
#import "SignupWithEmailViewController.h"
@interface SquadInfoViewController (){
    
    __weak IBOutlet UIImageView *infoImageView;
    __weak IBOutlet UIView *infoLastPageView;
    IBOutletCollection(UIView) NSArray *needBorderViews;
    int currentPage;
    IBOutletCollection(UIView)NSArray *roundedView;
   
    __weak IBOutlet UILabel *signupInfoLabel;
    __weak IBOutlet UILabel *freeWorkoutInfoLabel;
    __weak IBOutlet UIButton *backButton;
    
    __weak IBOutlet UIScrollView *mainScroll;
    __weak IBOutlet UIScrollView *lastViewScroll;
    __weak IBOutlet UIScrollView *mannyScrollView;
    __weak IBOutlet UILabel *workoutLabel;
    __weak IBOutlet UILabel *infoLabel;
    __weak IBOutlet UIView *firstView;
    __weak IBOutlet UIView *lastView;
    __weak IBOutlet UIButton *startNowButton;
    __weak IBOutlet UILabel *gratefulLabel;
    
    __weak IBOutlet UIButton *gratefulBtn;
    __weak IBOutlet UITextView *greateFulTextView;
    __weak IBOutlet UIView *congratsView;
    IBOutletCollection(UIButton) NSArray *congratsBtnArry;
    __weak IBOutlet UIView *nonSubcribedView;
    __weak IBOutlet UIButton *nonSubYesBtn;
    __weak IBOutlet UIView *freeModeView;
    __weak IBOutlet UIButton *createMyHappinessHabitBtn;
    __weak IBOutlet UIView *mannypopUpview;
    __weak IBOutlet UITextView *mannyTextview;
    __weak IBOutlet UILabel *mannyLabel;
    __weak IBOutlet UIButton *mannyButton;
    __weak IBOutlet NSLayoutConstraint *heightForGrateFulText;
    __weak IBOutlet NSLayoutConstraint *heightForMannyFulText;
    BOOL ismanny;
    UITextField *activeTextField;
    UITextView *activeTextView;
    CGFloat SCROLLWIDTH;
    BOOL pageControlIsChangingPage;
    CGFloat oldInset;
    UIToolbar *numberToolbar;
    NSString *savehtmlText;
}

@end

@implementation SquadInfoViewController

#pragma mark - View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //infoLastPageView.hidden = false;
    for(UIView *view in needBorderViews){
        view.layer.borderColor = [UIColor whiteColor].CGColor;
        view.layer.borderWidth = 2.0;
    }
    for(UIButton *congratsbtn in congratsBtnArry){
        congratsbtn.layer.cornerRadius = 15;
        congratsbtn.layer.masksToBounds = YES;
    }
    nonSubYesBtn.layer.cornerRadius = 15;
    nonSubYesBtn.layer.masksToBounds = YES;
    mannyButton.layer.cornerRadius = 15;
    mannyButton.layer.masksToBounds = YES;
    createMyHappinessHabitBtn.layer.cornerRadius = 15;
    createMyHappinessHabitBtn.layer.masksToBounds = YES;
    gratefulBtn.layer.cornerRadius = 15;
    gratefulBtn.layer.masksToBounds = YES;
    currentPage = 2;
    
    [self registerForKeyboardNotifications];
    numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone  target:self action:@selector(doneWithFirstResponder)],nil];
    [numberToolbar sizeToFit];
    greateFulTextView.inputAccessoryView = numberToolbar;
    
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(tapAction:)];
    tapGesture.numberOfTapsRequired = 1;
    [mainScroll addGestureRecognizer:tapGesture];
    
    for(UIView *view in roundedView){
        view.layer.cornerRadius = 25.0;
        view.clipsToBounds = YES;
    }
 
    [self setSignUpInfoLabel];
    [self setFreeWorkoutInfoLabel];
    
    // Create the data model
//    NSMutableArray *arr = [NSMutableArray new];
//    for (int i = 1; i <= 8; i++) {
//        [arr addObject:[@"" stringByAppendingFormat:@"mbhq_bg_%d.png",i]];
//    }
//    self.pageImages = arr;
//    self.pageControl.currentPage = 0;
//    self.pageControl.numberOfPages = self.pageImages.count;
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"You’re in, and you’re one step closer to being the healthiest version of yourself!"]];
    NSRange foundRange = [text.mutableString rangeOfString:@"healthiest"];
    
    NSDictionary *attrDict = @{
                               NSFontAttributeName : [UIFont fontWithName:@"Raleway-Medium" size:20.0],
                               NSForegroundColorAttributeName : squadMainColor
                               
                               };
    [text addAttributes:attrDict range:NSMakeRange(0, text.length)];
    [text addAttributes:@{
                          NSFontAttributeName : [UIFont fontWithName:@"Raleway-SemiBold" size:20.0]
                          
                          }
                  range:foundRange];
    workoutLabel.attributedText = text;
    NSMutableAttributedString *text1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"We can’t wait to help you reach your health and fitness goals!"]];
    NSRange foundRange1 = [text1.mutableString rangeOfString:@"health and fitness goals!"];
    
    NSDictionary *attrDict1 = @{
                               NSFontAttributeName : [UIFont fontWithName:@"Raleway-Medium" size:20.0],
                               NSForegroundColorAttributeName : squadMainColor
                               
                               };
    [text1 addAttributes:attrDict1 range:NSMakeRange(0, text1.length)];
    [text1 addAttributes:@{
                          NSFontAttributeName : [UIFont fontWithName:@"Raleway-SemiBold" size:20.0]
                          
                          }
                  range:foundRange1];
    infoLabel.attributedText = text1;
    startNowButton.layer.cornerRadius=20;
    startNowButton.layer.masksToBounds=YES;
    firstView.hidden = true;
    lastView.hidden = true;
    congratsView.hidden = true;
    nonSubcribedView.hidden = true;
    freeModeView.hidden = true;
    mainScroll.hidden = false;
    self.pageControl.hidden = false;
    [self startWalkthrough:nil];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (!lastView.hidden && mannypopUpview.hidden) {
        heightForGrateFulText.constant = greateFulTextView.contentSize.height;
    }else if (!mannypopUpview.hidden){
        heightForMannyFulText.constant = mannyTextview.contentSize.height;
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - End
#pragma mark - Private Method
-(void)setSignUpInfoLabel{
    NSString *textStr = @"Transform your body with customised nutrition and workout plans, goal setting, seminars and more!";
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:textStr];
    
    
    
    NSMutableParagraphStyle *paragraphStyle = NSMutableParagraphStyle.new;
    paragraphStyle.alignment                = NSTextAlignmentCenter;
    
    NSDictionary *attrDict = @{
                               NSFontAttributeName : [UIFont fontWithName:@"Raleway-Medium" size:14.0],
                               NSForegroundColorAttributeName : [UIColor whiteColor],
                               NSParagraphStyleAttributeName:paragraphStyle
                               };
    [text addAttributes:attrDict range:NSMakeRange(0,text.length)];
    
    NSDictionary *attrDict1 = @{
                                NSFontAttributeName : [UIFont fontWithName:@"Raleway-Bold" size:14.0],
                                NSForegroundColorAttributeName : [UIColor whiteColor],
                                NSParagraphStyleAttributeName:paragraphStyle
                                };
    [text addAttributes:attrDict1 range:[textStr rangeOfString:@"customised nutrition and workout plans, goal setting, seminars"]];
    
    signupInfoLabel.attributedText = text;
}
-(void)setFreeWorkoutInfoLabel{
    NSString *textStr = @"Access our library of over 1500 killer workouts and join our community for FREE!";
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:textStr];
    
    
    
    NSMutableParagraphStyle *paragraphStyle = NSMutableParagraphStyle.new;
    paragraphStyle.alignment                = NSTextAlignmentCenter;
    
    NSDictionary *attrDict = @{
                               NSFontAttributeName : [UIFont fontWithName:@"Raleway-Medium" size:14.0],
                               NSForegroundColorAttributeName : [UIColor whiteColor],
                               NSParagraphStyleAttributeName:paragraphStyle
                               };
    [text addAttributes:attrDict range:NSMakeRange(0,text.length)];
    
    NSDictionary *attrDict1 = @{
                                NSFontAttributeName : [UIFont fontWithName:@"Raleway-Bold" size:14.0],
                                NSForegroundColorAttributeName : [UIColor whiteColor],
                                NSParagraphStyleAttributeName:paragraphStyle
                                };
    [text addAttributes:attrDict1 range:[textStr rangeOfString:@"1500 killer workouts"]];
    
    freeWorkoutInfoLabel.attributedText = text;
}
-(void)setGrateFulTextLabel{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:@"So tell me..."];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Raleway-Medium" size:17] range:NSMakeRange(0, [attributedString length])];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, [attributedString length])];
    
    NSMutableAttributedString *attributedString2 = [[NSMutableAttributedString alloc]initWithString:@"\n\nWhat are you \ngrateful for today?"];
    [attributedString2 addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Raleway-SemiBold" size:27] range:NSMakeRange(0, [attributedString2 length])];
    [attributedString2 addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, [attributedString2 length])];
    
    [attributedString appendAttributedString:attributedString2];
    gratefulLabel.attributedText = attributedString;
}
-(void)setMannyFulTextLabel{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:@"So tell me..."];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Raleway-Medium" size:17] range:NSMakeRange(0, [attributedString length])];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, [attributedString length])];
    
    NSMutableAttributedString *attributedString2 = [[NSMutableAttributedString alloc]initWithString:@"\n\nWhat are you \ngrateful for today?"];
    [attributedString2 addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Raleway-SemiBold" size:27] range:NSMakeRange(0, [attributedString2 length])];
    [attributedString2 addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, [attributedString2 length])];
    
    [attributedString appendAttributedString:attributedString2];
    mannyLabel.attributedText = attributedString;
}
-(void)doneWithFirstResponder{
    [self.view endEditing:YES];
//    [self gratefulButonActivity:greateFulTextView.text];
    [Utility setTheCursorPosition:greateFulTextView];
    [Utility setTheCursorPosition:mannyTextview];
    if (!lastView.hidden && mannypopUpview.hidden) {
        int height = [[UIScreen mainScreen]bounds].size.height;
        heightForGrateFulText.constant = height - (200+45+20);
        
    }else if (!mannypopUpview.hidden){
        int height = [[UIScreen mainScreen]bounds].size.height;
        heightForMannyFulText.constant = height - (250+200+50);
    }
}
-(void)gratefulButonActivity:(NSString*)text{
    NSString *trimstr = [[text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    if ([Utility isEmptyCheck:trimstr]) {
        gratefulBtn.userInteractionEnabled = false;
        gratefulBtn.alpha = 0.5;
    }else{
        gratefulBtn.userInteractionEnabled = true;
        gratefulBtn.alpha = 1.0;
    }
}
-(void)updateTrial{
    [defaults setObject:[NSDate date] forKey:@"TrialStartDate"];
    [defaults setObject:[NSDate date] forKey:@"QuoteStartDate"];
    //[defaults setBool:NO forKey:@"CompletedStartupChecklist"]; //AmitY
    [defaults setBool:YES forKey:@"CompletedStartupChecklist"]; //AmitY
    [defaults setBool:YES forKey:@"HasTrialAvail"];
    
    [AppDelegate updateTrialStartDate];
    
    [Utility cancelscheduleLocalNotificationsForFreeUser];
    [Utility cancelscheduleLocalNotificationsForQuote];
    [AppDelegate scheduleLocalNotificationsForFreeUser];
    [AppDelegate scheduleLocalNotificationsForQuote:![defaults boolForKey:@"isInitialQuoteSet"]];
    freeModeView.hidden = true;
//    nonSubcribedView.hidden = true;
    
}
-(void)videoUrlTapped:(NSString*)videoStr{
    HelpVideoPlayerViewController *helpVideoPlayerViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HelpVideoPlayerView"];
    helpVideoPlayerViewController.modalPresentationStyle = UIModalPresentationCustom;
    helpVideoPlayerViewController.videoURLString = videoStr;
    helpVideoPlayerViewController.isFromMessage = YES;
    helpVideoPlayerViewController.delegate = self;
    [self presentViewController:helpVideoPlayerViewController animated:YES completion:nil];
}
-(void)checkNonSubcribedUser{
    freeModeView.hidden = true;
    firstView.hidden = true;
    lastView.hidden = true;
    congratsView.hidden = true;
    
    if ([defaults boolForKey:@"IsNonSubscribedUser"]) {
        nonSubcribedView.hidden = false;
    }else{
        nonSubcribedView.hidden = true;
        [self tryNowButtonPressed:0];
    }
}
-(void)alertForSpeak{
    NSString *str = @"Want to 'talk' instead of 'type'? Click and choose your microphone!";
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@""
                                          message:str
                                          preferredStyle:UIAlertControllerStyleAlert];
    [alertController setValue:[Utility getattributedMessage:str] forKey:@"attributedMessage"];

    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:@"OK"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   
                               }];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
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
    if (!isAdd) {
        NSLog(@"Data not inseted");
    }
     self->firstView.hidden = true;
     self->lastView.hidden = true;
     self->nonSubcribedView.hidden = true;
     self->freeModeView.hidden = true;
     self->congratsView.hidden = false;

}

-(NSDictionary*)setUpGratitudeDetails{
    NSMutableDictionary *gratitudeData = [[NSMutableDictionary alloc]init];
           
           [gratitudeData setObject:[@"" stringByAppendingFormat:@"%@",greateFulTextView.text] forKey:@"Name"];//Today I am grateful for:
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
           [gratitudeData setObject:[format stringFromDate:[NSDate date]] forKey:@"CreatedAtString"];
     
    return [gratitudeData mutableCopy];
}
-(void)goToDashBoard{
     ECSlidingViewController *slider=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SlidingView"];
       HomePageViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HomePage"];
       controller.sendToDailyWorkout = true;
       NavigationViewController *nav = [[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NavigationViewController"]initWithRootViewController:controller];
       slider.topViewController = nav;
       [slider resetTopViewAnimated:NO];
       [self.navigationController pushViewController:slider animated:NO];
}
#pragma mark - End

#pragma mark - Web Service

-(void)saveDataMultiPart{
    if (Utility.reachable) {
       
        NSDictionary *gratitudedata = [self setUpGratitudeDetails];
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:gratitudedata forKey:@"model"];
        
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
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
        [self presentViewController:controller animated:YES completion:nil];
    }else{
        NSDictionary *gratitudedata = [self setUpGratitudeDetails];
        [self addUpdateDB:gratitudedata];
        
    }
    
}
#pragma mark - End

#pragma mark - IBAction
- (IBAction)signupButtonPressed:(UIButton *)sender {
    [defaults setObject:nil forKey:@"taskListArray"];
    [defaults setBool:YES forKey:@"isFirstTimeForum"];
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

- (IBAction)tryNowButtonPressed:(UIButton *)sender {
    [defaults setObject:nil forKey:@"taskListArray"];
    [defaults setBool:YES forKey:@"isFirstTimeForum"];
     dispatch_async(dispatch_get_main_queue(), ^{
        ECSlidingViewController *slider=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SlidingView"];
        HomePageViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HomePage"];
        NavigationViewController *nav = [[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NavigationViewController"]initWithRootViewController:controller];
        slider.topViewController = nav;
        [slider resetTopViewAnimated:NO];
        [self.navigationController pushViewController:slider animated:NO];
     });
}
- (IBAction)backButtonPressed:(UIButton *)sender {
    [Utility logoutChatSdk];
    [defaults removeObjectForKey:@"TempTrialEndDate"];
    [defaults setBool:NO forKey:@"isOffline"];
    [defaults setBool:NO forKey:@"isSquadLite"];
    [defaults setBool:NO forKey:@"IsNonSubscribedUser"];
    [defaults setBool:NO forKey:@"isInitialNotiSet"];
    
    [defaults setObject:nil forKey:@"NonSubscribedUserData"];
    [defaults setObject:nil forKey:@"LoginData"];
    [defaults setObject:nil forKey:@"UserID"];
    [defaults setObject:nil forKey:@"UserSessionID"];
    [defaults setObject:nil forKey:@"ABBBCOnlineUserId"];
    [defaults setObject:nil forKey:@"ABBBCOnlineUserSessionId"];
    [defaults setObject:nil forKey:@"Email"];
    [defaults setObject:nil forKey:@"Password"];
    [defaults setObject:[NSNumber numberWithInt:-1] forKey:@"UserID"];
    [defaults setObject:[NSNumber numberWithInt:-1] forKey:@"UserSessionID"];
    [defaults setObject:[NSNumber numberWithInt:-1] forKey:@"ABBBCOnlineUserId"];
    [defaults setObject:[NSNumber numberWithInt:-1] forKey:@"ABBBCOnlineUserSessionId"];
    NSArray *controllerArray = self.navigationController.viewControllers;
    UIViewController *controller = controllerArray[controllerArray.count-3];
    [self.navigationController popToViewController:controller animated:YES];
}
- (IBAction)startWalkthrough:(id)sender{
//    SCROLLWIDTH = [UIScreen mainScreen].bounds.size.width;
//    mainScroll.contentSize = CGSizeMake(SCROLLWIDTH * self.pageImages.count, mainScroll.frame.size.height);
//    for (int i = 0; i < self.pageImages.count; i++) {
//        UIImageView *imageView = [[UIImageView alloc]initWithFrame: CGRectMake(SCROLLWIDTH * i, 0, mainScroll.frame.size.width, mainScroll.frame.size.height)];
//
//        [imageView setImage:[UIImage imageNamed:self.pageImages[i]]];
//        imageView.contentMode = UIViewContentModeScaleToFill;
//        [mainScroll addSubview:imageView];
//    }
//
//    [self changePage:0];
//
    firstView.hidden = true;
    lastView.hidden = true;
    mainScroll.hidden = false;
    self.pageControl.hidden = false;
}
- (IBAction)workoutNowPressed:(id)sender{
    [defaults setObject:nil forKey:@"taskListArray"];
    [defaults setBool:YES forKey:@"isFirstTimeForum"];
    
    ECSlidingViewController *slider=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SlidingView"];
    HomePageViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HomePage"];
    controller.sendToDailyWorkout = true;
    NavigationViewController *nav = [[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NavigationViewController"]initWithRootViewController:controller];
    slider.topViewController = nav;
    [slider resetTopViewAnimated:NO];
    [self.navigationController pushViewController:slider animated:NO];
}
-(IBAction)startNowButtonPressed:(id)sender{
    [self workoutNowPressed:nil];
}
-(IBAction)grateFulButtonPressed:(id)sender{
    if ((!(greateFulTextView.text.length>5)) || [greateFulTextView.text isEqualToString:@"Start typing"] || [Utility isEmptyCheck:greateFulTextView.text]) {
        mannypopUpview.hidden = false;
        [self setMannyFulTextLabel];
        [Utility setTheCursorPosition:mannyTextview];
        ismanny = true;
    }else{
         mannypopUpview.hidden = true;
         ismanny = false;
         [self saveDataMultiPart];
    }
   
   
}
-(IBAction)thanksmannyPressed:(id)sender{
    if (![Utility isEmptyCheck:mannyTextview.text] && (mannyTextview.text.length>5) && ![mannyTextview.text isEqualToString:@"Start typing"]) {
            greateFulTextView.text = mannyTextview.text;
            [self saveDataMultiPart];
    }else{
        [Utility msg:@"Please tell us briefly what are you grateful for today" title:@"" controller:self haveToPop:NO];
    }
}

-(IBAction)congratsButonPressed:(UIButton*)sender{
    if(sender.tag == 1){ //Quicktour
        NSString *str = @"https://player.vimeo.com/external/390132163.m3u8?s=854127a9dab2773e57d1c8be4b96b7971e418b6e";
        [self videoUrlTapped:str];
    }else{ //Explore
        [self checkNonSubcribedUser];
    }
}
-(IBAction)nonSubDetailsButton:(UIButton*)sender{
    if (sender.tag == 1) {//Yes
        [self freeVersionTapped:0];
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
    }else{//no thanks
//        freeModeView.hidden = false;
        [self freeVersionTapped:0];
        [self tryNowButtonPressed:0];
    }
}
-(IBAction)freeVersionTapped:(id)sender{
    [self updateTrial];
}
-(IBAction)createMyHapinessHabitBtnPressed:(id)sender{
    [defaults setObject:nil forKey:@"taskListArray"];
    [defaults setBool:YES forKey:@"isFirstTimeForum"];
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

#pragma mark changePage
-(IBAction)changePage:(id)sender
{
    //move the scroll view
    CGRect frame = mainScroll.frame;
    frame.origin.x = frame.size.width * self.pageControl.currentPage;
    frame.origin.y = 0;
    //    frame.origin.x = frame.size.width * 1;
    [mainScroll scrollRectToVisible:frame animated:YES];
    //scrollViewDidEndDecelerating will turn this off
    pageControlIsChangingPage = YES;
}
#pragma mark - UITapGesture Action
- (void)tapAction:(UITapGestureRecognizer *)tap
{
    // do stuff
//    currentPage ++;
//    if(currentPage >6){
//        infoLastPageView.hidden = false;
//    }else{
//        NSString *pageImageName = [@"" stringByAppendingFormat:@"bg_%d.png",currentPage];
//        [infoImageView setImage:[UIImage imageNamed:pageImageName]];
//    }
   
    if(self.pageControl.currentPage == self.pageControl.numberOfPages-1){
        mainScroll.hidden = true;
        self.pageControl.hidden = true;
        firstView.hidden = true;
        congratsView.hidden = true;
        lastView.hidden = false;
        mannypopUpview.hidden = true;
        nonSubcribedView.hidden = true;
        freeModeView.hidden = true;
        [Utility setTheCursorPosition:greateFulTextView];
        [self setGrateFulTextLabel];
        [self alertForSpeak];
//        [self goToDashBoard];
//        [self gratefulButonActivity:0];
        return;
    }
    self.pageControl.currentPage = self.pageControl.currentPage+1;
    [self changePage:0];
}
#pragma mark - End

#pragma mark - UIScrollViewDelegate method

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ((scrollView.contentOffset.x + scrollView.frame.size.width) > scrollView.contentSize.width) {
        mainScroll.hidden = true;
        self.pageControl.hidden = true;
        firstView.hidden = true;
        congratsView.hidden = true;
        lastView.hidden = false;
        mannypopUpview.hidden = true;
        nonSubcribedView.hidden = true;
        freeModeView.hidden = true;
        [Utility setTheCursorPosition:greateFulTextView];
        [self setGrateFulTextLabel];
        [self alertForSpeak];
//        [self goToDashBoard];

//        [self gratefulButonActivity:0];
        return;
    }
    if (pageControlIsChangingPage) {
        return;
    }
    CGFloat pageWidth = mainScroll.frame.size.width;
    float fractionalPage = mainScroll.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
    self.pageControl.currentPage = page;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    pageControlIsChangingPage = NO;
//    uint page = mainScroll.contentOffset.x / SCROLLWIDTH;
//    [self.pageControl setCurrentPage:page];
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
    CGRect aRect;
    if (mannypopUpview.hidden) {
        lastViewScroll.contentInset = contentInsets;
        lastViewScroll.scrollIndicatorInsets = contentInsets;
        aRect = lastViewScroll.frame;
    }else{
        mannyScrollView.contentInset =contentInsets;
        mannyScrollView.scrollIndicatorInsets = contentInsets;
        aRect = mannyScrollView.frame;
    }
    float x;
    if (activeTextView==nil) {
        x=aRect.size.height-activeTextField.frame.origin.y-activeTextField.frame.size.height;
        aRect.size.height -= kbSize.height;
        if (x < kbSize.height) {
            CGPoint scrollPoint = CGPointMake(0.0, kbSize.height+5-x);
            [lastViewScroll setContentOffset:scrollPoint animated:YES];
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
                if (mannypopUpview.hidden) {
                    [lastViewScroll scrollRectToVisible:aRect animated:YES];
                }else{
                    [mannyScrollView scrollRectToVisible:aRect animated:YES];
                }

            }

        }
    else{
        x=aRect.size.height-activeTextView.superview.frame.origin.y-activeTextView.superview.frame.size.height;
        aRect.size.height -= kbSize.height;
        if (x < kbSize.height) {
            CGPoint scrollPoint = CGPointMake(0.0, kbSize.height+5-x);
            [lastViewScroll setContentOffset:scrollPoint animated:YES];
        }
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    if (mannypopUpview.hidden) {
        lastViewScroll.contentInset = contentInsets;
        lastViewScroll.scrollIndicatorInsets = contentInsets;
    }else{
        mannyScrollView.contentInset = contentInsets;
        mannyScrollView.scrollIndicatorInsets = contentInsets;
    }
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
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
//    NotesViewController *controller =[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NotesView"];
//    controller.notesDelegate = self;
//    controller.modalPresentationStyle = UIModalPresentationCustom;
//    controller.textView = self->greateFulTextView;
//    if (![greateFulTextView.text isEqualToString:@""]) {
//            controller.htmlEditText = savehtmlText;
//        }
//    [self presentViewController:controller animated:NO completion:nil];
    [Utility removeCursor:textView];
    activeTextView = textView;
    [textView setInputAccessoryView:numberToolbar];
    return YES;
}
- (void)textViewDidBeginEditing:(UITextView *)textView{
//    [self.view endEditing:YES];
     if([greateFulTextView.text caseInsensitiveCompare:@"Start typing"] == NSOrderedSame){
         greateFulTextView.text = @"";
    }
     if([mannyTextview.text caseInsensitiveCompare:@"Start typing"] == NSOrderedSame){
          mannyTextview.text = @"";
     }
    activeTextView=textView;
    activeTextField=nil;
//    [self gratefulButonActivity:textView.text];
}

- (void)textViewDidEndEditing:(UITextView *)textView{
//     [self.view endEditing:YES];
    activeTextView=nil;
//    [self gratefulButonActivity:textView.text];
}

#pragma mark - progressbar delegate
- (void)completedWithResponse:(NSString *)responseString responseDict:(NSDictionary *)responseDict{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"SuccessFlag"] boolValue]) {
            self->firstView.hidden = true;
            self->lastView.hidden = true;
            self->nonSubcribedView.hidden = true;
            self->freeModeView.hidden = true;
            self->congratsView.hidden = true;
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd"];
            NSString *dateStr = [formatter stringFromDate:[NSDate date]];
            if(![Utility isEmptyCheck:responseDict[@"Details"]]){
                NSDictionary *gratitudeDict = responseDict[@"Details"];
                
                NSString *detailsString = @"";
               
                NSError *error;
                NSData *offlineData = [NSJSONSerialization dataWithJSONObject:gratitudeDict options:NSJSONWritingPrettyPrinted  error:&error];
                if (error) {
                    NSLog(@"Error Favorite Array-%@",error.debugDescription);
                    return;
                }
                detailsString = [[NSString alloc] initWithData:offlineData encoding:NSUTF8StringEncoding];
                
                
                [DBQuery addGratitudeDetails:[[gratitudeDict objectForKey:@"Id"]intValue] with:detailsString addedDate:dateStr isSync:1];
                [self goToDashBoard];
            }
        
        }else{
            NSDictionary *gratitudedata = [self setUpGratitudeDetails];
            [self addUpdateDB:gratitudedata];
//            [Utility msg:[responseDict objectForKey:@"ErrorMessage"] title:@"Error !" controller:self haveToPop:NO];
//            return;
        }
    });
}
- (void) completedWithError:(NSError *)error{
    [Utility msg:error.localizedDescription title:@"Error !" controller:self haveToPop:NO];
}

#pragma mark - Help Video Player Delegate
-(void)controllerDismissed{
    [self tryNowButtonPressed:0];
//    [self checkNonSubcribedUser];
}

#pragma mark - Notes Delegate

-(void)saveButtonDetails:(NSString *)saveText with:(UITextView *)textview{
    [textview setContentOffset:CGPointZero animated:NO];
    savehtmlText = saveText;
    greateFulTextView.attributedText = [Utility converHtmltotext:saveText];
//    [self gratefulButonActivity:[greateFulTextView.attributedText string]];
    [Utility setTheCursorPosition:greateFulTextView];
}
-(void)cancelNotes{
    
}
@end
