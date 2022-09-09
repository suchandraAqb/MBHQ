//
//  AddVisionBoardViewController.m
//  Squad
//
//  Created by AQB SOLUTIONS on 15/03/2017.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import "AddVisionBoardViewController.h"
#import "Utility.h"
#import "NSString+HTML.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "SongPlayListViewController.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "ProgressBarViewController.h"
#import "VisionCollectionViewCell.h"
#import "QBImagePickerController.h"
#import "DisplayImageViewController.h"
#import "VisionGoalActionTableViewCell.h"
#import "NotesViewController.h"
#import "GratitudeListViewController.h"

@interface AddVisionBoardViewController ()<SPTAudioStreamingDelegate,SPTAudioStreamingPlaybackDelegate> {
    IBOutlet UIButton *uploadImageButton;
    IBOutlet UIButton *visionDateButton;
    IBOutlet UISwitch *setReminderSwitch;
    IBOutlet UISwitch *setReminderSwitch_statement;
    IBOutlet UIButton *deleteButton;
    IBOutlet UIScrollView *mainScroll;
    IBOutlet UIStackView *mainStackView;
    IBOutlet UIView *lastView;
    IBOutlet UIImageView *visionImageView;
    __weak IBOutlet NSLayoutConstraint *visionImageViewHeight;
    __weak IBOutlet UIView *changePicView;
   // IBOutlet UIView *webViewContainer;
    IBOutlet UIButton *editButton;
    IBOutlet UIButton *saveButton;
    IBOutlet UIButton *printButton;
    IBOutlet UILabel *visionLabel;
    IBOutlet UIView *visionDateView;
    IBOutlet UIView *visionReminderView;
    IBOutlet UIView *visionLabelView;
    IBOutlet UIButton *doneButton;
    IBOutlet UIButton *backButton;
    IBOutlet UIButton *cancelButton;
    IBOutlet UIButton *addTextButton;
    IBOutlet UIButton *viewReminder;
    IBOutlet UIButton *viewReminder_statement;
   
    IBOutlet UIButton *addEditImageBtn;
    IBOutlet UIButton *alarmButton;
    IBOutlet UITableView *statementTable;
    IBOutlet UIButton *statementButton;
    IBOutlet UIButton *boardButton;
     NSMutableDictionary *visionDict;
    
    NSMutableDictionary *resultDict;
    UIView *contentView;
    NSDate *selectedDate;
    UIImage *chosenImage;
    BOOL isEdit;
    NSString *visionText;
    
    //ah song
    IBOutlet UIView *songView;
    IBOutlet UIButton *selectSongButton;
    
    AVAudioPlayer *player;
    
    NSMutableDictionary *savedReminderDict;
    BOOL isChanged;
    BOOL isFirstTimeReminderSet;//gami_badge_popup
    
    NSMutableArray *imageArray;
    __weak IBOutlet UIView *editView;
    __weak IBOutlet UIView *showHideView;
    __weak IBOutlet UIImageView *arrowImage;
    __weak IBOutlet UIButton *showButton;
    int selectedImage;
    
    int editRow;
    NSMutableArray *statementList;
    UITextView *activeTextView;
    UIToolbar *numberToolbar;
    
    IBOutlet UIView *visionStatementView;
    IBOutlet UIView *emptyAddImageView;
    
    IBOutlet UIButton *addImgButton;
    
    IBOutlet UIButton *visionStatementDtBtn;
    
    IBOutlet UIView *notificationView;
    
    IBOutlet UIView *statementReminderView;
    NSString *localImageName;
    NSString *prvlocalImageName;
    IBOutlet UIView *infoView;
    IBOutlet UIButton *clickNowButton;
    IBOutlet UIView *infoSubView;
    
    BOOL isVisionEdited;
    BOOL isStatementEdited;
    BOOL isExistingImageChange;
    
    
    
}

@end

@implementation AddVisionBoardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"CurrentFile Name: %@",[Utility createImageFileNameFromTimeStamp]);
    localImageName = [Utility createImageFileNameFromTimeStamp];
    // Do any additional setup after loading the view.
    imageArray = [NSMutableArray new];
    resultDict = [[NSMutableDictionary alloc]init];
   
    isFirstTimeReminderSet = true;
  
    boardButton.selected = true;
    
    //Save Button Curve
    saveButton.layer.borderColor = [UIColor colorWithRed:50.0 / 255.0 green:205.0 / 255.0 blue:184.0 / 255.0 alpha:1.0].CGColor;
    saveButton.clipsToBounds = YES;
    saveButton.layer.borderWidth = 1.2;
    saveButton.layer.cornerRadius = 13;
    
    //Print Button Curve
    printButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [printButton setBackgroundColor:[UIColor lightGrayColor]];
    printButton.clipsToBounds = YES;
    printButton.layer.borderWidth = 1.2;
    printButton.layer.cornerRadius = 13;
    
    //ChangeImage Button Curve
    addEditImageBtn.layer.borderColor = [UIColor colorWithRed:50.0 / 255.0 green:205.0 / 255.0 blue:184.0 / 255.0 alpha:1.0].CGColor;
    addEditImageBtn.clipsToBounds = YES;
    addEditImageBtn.layer.borderWidth = 1.2;
    addEditImageBtn.layer.cornerRadius = 13;
    
    addImgButton.layer.borderColor = [UIColor colorWithRed:50.0 / 255.0 green:205.0 / 255.0 blue:184.0 / 255.0 alpha:1.0].CGColor;
    addImgButton.clipsToBounds = YES;
    addImgButton.layer.borderWidth = 1.2;
    addImgButton.layer.cornerRadius = 13;
    //****
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setYear:1];
    NSDate *newDate = [cal dateByAddingComponents:dateComponents toDate:[NSDate date] options:0];
    selectedDate = newDate;
    savedReminderDict = [[NSMutableDictionary alloc] init];
  
    if (![Utility isEmptyCheck:_visionBoardDict]) {
        NSArray *arr = [_visionBoardDict objectForKey:@"GoalVisionBoardImagesModelList"];
        if (![Utility isEmptyCheck:arr]) {
            [self->imageArray addObjectsFromArray:arr];
            uploadImageButton.hidden = true;
            changePicView.hidden = false;
        }else{
            uploadImageButton.hidden = false;
//            changePicView.hidden = true;
        }
    }else{
        uploadImageButton.hidden = false;
    }
    
    if ([Utility isEmptyCheck:[defaults objectForKey:@"isFirstTimeVision"]]) {
//        [Utility showHelpAlertWithURL:@"https://player.vimeo.com/external/125750379.m3u8?s=c85a3928071e47c744698cf66662e8543adcf3f8" controller:self haveToPop:NO];
        infoView.hidden=false;
        [defaults setObject:[NSNumber numberWithBool:false] forKey:@"isFirstTimeVision"];
    }else{
        infoView.hidden=true;
    }
    
    //***Statement***
    isChanged = NO;
    isFirstTimeReminderSet = true;
    statementTable.hidden = true;
    statementReminderView.hidden=true;
    printButton.hidden=true;
    notificationView.hidden = true;
    visionStatementDtBtn.hidden = true;
    statementButton.selected = false;
    _visionBoardDict = [NSMutableDictionary new];
    statementList = [NSMutableArray new];
    //isEdit = false;
    editRow = -1;
    
    numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone  target:self action:@selector(doneWithFirstResponder)],nil];
    [numberToolbar sizeToFit];
    [self registerForKeyboardNotifications];
    
    visionImageView.userInteractionEnabled = true;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(tapAction:)];
    tapGesture.numberOfTapsRequired = 1;
    [visionImageView addGestureRecognizer:tapGesture];
    
    
    [clickNowButton setBackgroundColor:[UIColor colorWithRed:50.0 / 255.0 green:205.0 / 255.0 blue:184.0 / 255.0 alpha:1.0]];
    clickNowButton.layer.cornerRadius=clickNowButton.frame.size.height/2.0;
    infoSubView.layer.cornerRadius=10;
    
    
    isVisionEdited=NO;
    isStatementEdited=NO;
    
    //*****Statement*****
     [self setSaveButton];
    [self prepareView];
    [self getData];
    
   
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(quitList:) name:@"backButtonPressed" object:nil];
   
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
    if (_isFromReminder) {
        _isFromReminder = false;
    }
   
    if ([Utility isEmptyCheck:_visionBoardDict] && _visionBoardDict.count == 0) {

        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];     //2017-03-06T10:38:18.7877+00:00
        NSString *currentDateStr = [formatter stringFromDate:selectedDate];
        NSString *newCurrentDateStr = [formatter stringFromDate:[NSDate date]];
        
        [resultDict setObject:[NSNumber numberWithInt:0] forKey:@"Id"];
        [resultDict setObject:@"" forKey:@"OnThisDateIwillLook"];
        [resultDict setObject:@"" forKey:@"OnThisDateIwillBeAbleTo"];
        [resultDict setObject:@"" forKey:@"OnThisDateIwillFeel"];
        [resultDict setObject:@"" forKey:@"OnThisDateIwillHave"];
        [resultDict setObject:currentDateStr forKey:@"VisionDate"];
        [resultDict setObject:[defaults objectForKey:@"UserID"] forKey:@"CreatedBy"];
        [resultDict setObject:currentDateStr forKey:@"reminder_till_date"];
        [resultDict setObject:newCurrentDateStr forKey:@"last_reminder_inserted_date"];
        [resultDict setObject:newCurrentDateStr forKey:@"CreatedAt"];
        [resultDict setObject:[NSNumber numberWithBool:NO] forKey:@"IsDeleted"];
        [resultDict setObject:[NSNumber numberWithBool:NO] forKey:@"Status"];
        [resultDict setObject:@"" forKey:@"Song"];
        
        [formatter setDateFormat:@"dd/MM/yyyy"];
        NSString *currentButtonDateStr = [formatter stringFromDate:selectedDate];
        [visionDateButton setTitle:currentButtonDateStr forState:UIControlStateNormal];
    } else if (![Utility isEmptyCheck:_visionBoardDict] && _visionBoardDict.count == 1) {  //<2 because it has OnThisDateIwillLook key

        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];     //2017-03-06T10:38:18.7877+00:00
        NSString *currentDateStr = [formatter stringFromDate:selectedDate];
        NSString *newCurrentDateStr = [formatter stringFromDate:[NSDate date]];
        
        [resultDict setObject:[NSNumber numberWithInt:0] forKey:@"Id"];
        [resultDict setObject:[_visionBoardDict objectForKey:@"OnThisDateIwillLook"] forKey:@"OnThisDateIwillLook"];
        [resultDict setObject:@"" forKey:@"OnThisDateIwillBeAbleTo"];
        [resultDict setObject:@"" forKey:@"OnThisDateIwillFeel"];
        [resultDict setObject:@"" forKey:@"OnThisDateIwillHave"];
        [resultDict setObject:currentDateStr forKey:@"VisionDate"];
        [resultDict setObject:[defaults objectForKey:@"UserID"] forKey:@"CreatedBy"];
        [resultDict setObject:currentDateStr forKey:@"reminder_till_date"];
        [resultDict setObject:newCurrentDateStr forKey:@"last_reminder_inserted_date"];
        [resultDict setObject:newCurrentDateStr forKey:@"CreatedAt"];
        [resultDict setObject:[NSNumber numberWithBool:NO] forKey:@"IsDeleted"];
        [resultDict setObject:[NSNumber numberWithBool:NO] forKey:@"Status"];
        [resultDict setObject:@"" forKey:@"Song"];
        
        [formatter setDateFormat:@"dd/MM/yyyy"];
        NSString *currentButtonDateStr = [formatter stringFromDate:selectedDate];
        [visionDateButton setTitle:currentButtonDateStr forState:UIControlStateNormal];
    }
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [self.view endEditing:YES];
//    [imageCollectionView removeObserver:self forKeyPath:@"contentSize"];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"backButtonPressed" object:nil];
    [player pause];
    if (self.sPlayer) {
        [self.sPlayer setIsPlaying:NO callback:nil];
    }
    
//    if (isChanged) {
//        UIAlertController *alertController = [UIAlertController
//                                              alertControllerWithTitle:@"Save Changes"
//                                              message:@"Your changes will be lost if you don’t save them."
//                                              preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *okAction = [UIAlertAction
//                                   actionWithTitle:@"Save"
//                                   style:UIAlertActionStyleDefault
//                                   handler:^(UIAlertAction *action)
//                                   {
//                                       [self saveButtonTapped:nil];
//                                   }];
//        UIAlertAction *cancelAction = [UIAlertAction
//                                       actionWithTitle:@"Don't Save"
//                                       style:UIAlertActionStyleDefault
//                                       handler:^(UIAlertAction *action)
//                                       {
//                                       }];
//        [alertController addAction:okAction];
//        [alertController addAction:cancelAction];
//        [self presentViewController:alertController animated:YES completion:nil];
//    }
    
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
//
}
#pragma mark - UITapGesture Action
- (void)tapAction:(UITapGestureRecognizer *)tap
{
    // do stuff
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appdelegate.autoRotate=YES;
    DisplayImageViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DisplayImage"];
    controller.modalPresentationStyle = UIModalPresentationCustom;
    controller.image = visionImageView.image;
    [self presentViewController:controller animated:YES completion:nil];
}
#pragma mark - Local Notification Observer and delegate

-(void)quitList:(NSNotification *)notification{
    
    NSString *text = notification.object;
    if([text isEqualToString:@"homeButtonPressed"]){
        [self logoTapped:0];
    }else{
        [self back:0];
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction

- (IBAction)printButtonPressed:(UIButton *)sender {
    [self webServicecallForEmailGoalVisionBoardStatementList];
}



- (IBAction)statementPictureEditButtonPressed:(UIButton *)sender {
    
    NSDictionary *dict = [statementList objectAtIndex:sender.tag];
    
    NSString *text = [@"" stringByAppendingFormat:@"%@",![Utility isEmptyCheck:[dict objectForKey:sender.accessibilityHint]]?[dict objectForKey:sender.accessibilityHint]:@""];
    NotesViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NotesView"];
    controller.visionStatementIndex=sender.tag;
    controller.visionStatementKey=sender.accessibilityHint;
    controller.notesDelegate=self;
    controller.fromStr=@"VisionStatement";
    controller.visionStatementText=text;
    [self.navigationController pushViewController:controller animated:NO];
    
}




- (IBAction)closeButtonPressed:(UIButton *)sender {
    infoView.hidden=true;
}
- (IBAction)clickNowButtonPressed:(UIButton *)sender {
    infoView.hidden=true;
    //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://mindbodyhq.com/blogs/how-to/how-to-create-your-vision-board"]];
    PrivacyPolicyAndTermsServiceViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PrivacyPolicyAndTermsService"];
    controller.modalPresentationStyle = UIModalPresentationCustom;
    controller.url=[NSURL URLWithString:VISION_INFO];
    controller.isFromCourse = YES;
    [self presentViewController:controller animated:YES completion:nil];
}

- (IBAction)infoPressed:(UIButton *)sender {
    infoView.hidden=false;
}



- (IBAction)back:(id)sender {
    [self shouldPopOnBackButtonWithResponse:^(BOOL shouldPop) {
        if (shouldPop)
            [self.navigationController popViewControllerAnimated:YES];
    }];
    [self->player pause];
    if (self.sPlayer) {
        [self.sPlayer setIsPlaying:NO callback:nil];
    }
}
- (IBAction)logoTapped:(id)sender {
    [self shouldPopOnBackButtonWithResponse:^(BOOL shouldPop) {
        if (shouldPop){
            if(([Utility isSubscribedUser] && [Utility isOfflineMode]) || [Utility isSquadLiteUser] || [Utility isSquadFreeUser]) {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }else{
//             TodayHomeViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"TodayHome"];
                GratitudeListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"GratitudeListView"];
                [self.navigationController pushViewController:controller animated:YES];
            }}
    }];
}
- (IBAction)doneTapped:(id)sender {    //ah 23.6
    //******** not in use ***************
    //    NSLog(@"res %@",resultDict);
    //    if ([self validationCheck]) {
    if (![Utility isEmptyCheck:[_visionBoardDict objectForKey:@"UploadVisionBoardImg"]] || ![Utility isEmptyCheck:chosenImage] || ![Utility isEmptyCheck:imageArray]) {
        [self saveDataWithMultipart];
    } else {
        [Utility msg:@"Please choose an image" title:@"Oops!" controller:self haveToPop:NO];
    }
}
- (IBAction)uploadImageTapped:(id)sender {

//    if([Utility isEmptyCheck:_visionBoardDict] && !_isFromReminder){
//        if([Utility isEmptyCheck:[defaults objectForKey:@"VisionHelpShow"]]){
//            [defaults setObject:[NSNumber numberWithBool:true] forKey:@"VisionHelpShow"];
//        }
//        if([[defaults objectForKey:@"VisionHelpShow"]boolValue]){
//            NSString *txt = @"Please Do 2 Things Before Uploading Your Vision Board\n\n1. Watch the 'how to create your vision' seminar.\n2. Create your vision board using a free vision board app, save the picture and then upload it here.";
//            UIAlertController *alertController = [UIAlertController
//                                                  alertControllerWithTitle:nil
//                                                  message:txt
//                                                  preferredStyle:UIAlertControllerStyleAlert];
//            UIAlertAction *okAction = [UIAlertAction
//                                       actionWithTitle:@"Close"
//                                       style:UIAlertActionStyleDefault
//                                       handler:^(UIAlertAction *action)
//                                       {
//                                           [self uploadImageAlert];
//
//                                       }];
//            UIAlertAction *cancelAction = [UIAlertAction
//                                           actionWithTitle:@"Dont show me again."
//                                           style:UIAlertActionStyleDefault
//                                           handler:^(UIAlertAction *action)
//                                           {
//                                               [defaults setObject:[NSNumber numberWithBool:false] forKey:@"VisionHelpShow"];
//                                               [self uploadImageAlert];
//                                           }];
//            [alertController addAction:okAction];
//            [alertController addAction:cancelAction];
//            [self presentViewController:alertController animated:YES completion:nil];
//        }
//    }else{
//         [self uploadImageAlert];
//    }
    [self uploadImageAlert];
}
- (IBAction)visionDateButtonTapped:(id)sender
{
    DatePickerViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DatePicker"];
    controller.modalPresentationStyle = UIModalPresentationCustom;
    controller.selectedDate = selectedDate;
    controller.datePickerMode = UIDatePickerModeDate;
    controller.delegate = self;
    controller.sender = sender;
    [self presentViewController:controller animated:YES completion:nil];
}

- (IBAction)setReminderValueChanged:(id)sender {
    [Utility startFlashingbutton:saveButton];
    if ([sender isOn]) {
        [setReminderSwitch setOn:YES];
        [setReminderSwitch_statement setOn:YES];
        SetReminderViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SetReminder"];
        if ([resultDict objectForKey:@"FrequencyId"] != nil)
            [resultDict setObject:[NSNumber numberWithBool:true] forKey:@"PushNotification"];
            controller.defaultSettingsDict = resultDict;
            controller.reminderDelegate = self;
        if (isFirstTimeReminderSet) {
            controller.isFirstTime = isFirstTimeReminderSet;
            isFirstTimeReminderSet = false;
        }
        controller.view.backgroundColor = [UIColor clearColor];
        controller.modalPresentationStyle = UIModalPresentationCustom;
        [self presentViewController:controller animated:YES completion:nil];
    } else {
        
        [setReminderSwitch setOn:YES];
        [setReminderSwitch_statement setOn:YES];

        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:nil
                                              message:nil
                                              preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:@"EDIT REMINDER"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                SetReminderViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SetReminder"];
                                    if ([self->resultDict objectForKey:@"FrequencyId"] != nil)
                                           [self->resultDict setObject:[NSNumber numberWithBool:true] forKey:@"PushNotification"];
                                           controller.defaultSettingsDict = self->resultDict;
                                           controller.reminderDelegate = self;
                                       if (self->isFirstTimeReminderSet) {
                                           controller.isFirstTime = self->isFirstTimeReminderSet;
                                           self->isFirstTimeReminderSet = false;
                                       }
                                       controller.view.backgroundColor = [UIColor clearColor];
                                       controller.modalPresentationStyle = UIModalPresentationCustom;
                                       [self presentViewController:controller animated:YES completion:nil];
//                                       [self viewReminder:0];
                                   }];
        UIAlertAction *turnOff = [UIAlertAction
                                  actionWithTitle:@"TURN OFF REMINDER"
                                  style:UIAlertActionStyleDefault
                                  handler:^(UIAlertAction *action)
                                  {
                                        [self->setReminderSwitch setOn:NO];
                                        [self->setReminderSwitch_statement setOn:NO];
                                      [self->resultDict removeObjectForKey:@"FrequencyId"];
                                      [self prepareReminderView];
                                  }];
//        UIAlertAction *cancelAction = [UIAlertAction
//                                       actionWithTitle:@"Cancel"
//                                       style:UIAlertActionStyleCancel
//                                       handler:^(UIAlertAction *action)
//                                       {
//                                        [self->setReminderSwitch setOn:NO];
//                                        [self->setReminderSwitch_statement setOn:NO];
//                                        [self->resultDict removeObjectForKey:@"FrequencyId"];
//                                        [self prepareReminderView];
//                                       }];
        [alertController addAction:okAction];
        [alertController addAction:turnOff];
//        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];

    }
}

- (IBAction)saveButtonTapped:(id)sender {
    
    if (boardButton.isSelected) {
        if (![Utility isEmptyCheck:[_visionBoardDict objectForKey:@"BoardImageDevicePath"]] || ![Utility isEmptyCheck:chosenImage]) {
            //NSArray *imageArray = [_visionBoardDict objectForKey:@"GoalVisionBoardImagesModelList"]; || ![Utility isEmptyCheck:imageArray]
                //going to save
        //        isChanged=false;
                if (!setReminderSwitch.isOn) {
                    UIAlertController *alertController = [UIAlertController
                                                          alertControllerWithTitle:nil
                                                          message:@"Would you like to set a reminder to help you stay accountable and achieve your vision?"
                                                          preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *okAction = [UIAlertAction
                                               actionWithTitle:@"Yes"
                                               style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction *action) {
                                                   [self->setReminderSwitch setOn:YES];
                                                   [self->setReminderSwitch_statement setOn:YES];
                                                   [self setReminderValueChanged:self->setReminderSwitch];
                                               }];
                    UIAlertAction *cancelAction = [UIAlertAction
                                                   actionWithTitle:@"No"
                                                   style:UIAlertActionStyleCancel
                                                   handler:^(UIAlertAction *action)
                                                   {
                                                       [self saveDataWithMultipart];
                                                   }];
                    [alertController addAction:okAction];
                    [alertController addAction:cancelAction];
                    
                    [self presentViewController:alertController animated:NO completion:nil];
                    
                }else{
                    [self saveDataWithMultipart];
                }
            } else {
                [Utility msg:@"Please choose an image" title:@"Oops!" controller:self haveToPop:NO];
            }
    }else{
        [self updateVisionBoardStatement];
    }
    
    
    
}
- (IBAction)openEditor:(id)sender
{
    PECropViewController *controller = [[PECropViewController alloc] init];
    controller.delegate = self;
    controller.image = chosenImage;
    visionImageView.image= chosenImage;
    controller.keepingCropAspectRatio = YES;
  
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
    }
    
    [self presentViewController:navigationController animated:YES completion:NULL];
}
-(IBAction)cancelTapped:(id)sender {
    [self shouldPopOnBackButtonWithResponse:^(BOOL shouldPop) {
        if (shouldPop){
            if(self->isEdit){
               
                [self prepareView];
            }else{
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }
    }];
}
-(IBAction)addTextTapped:(id)sender {
    AddVisionEntryViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AddVisionEntry"];
    controller.visionBoardDict = _visionBoardDict;
    controller.addVisionEntryDelegate = self;
    [self presentViewController:controller animated:YES completion:nil];
}
- (IBAction)viewReminder:(UIButton *)sender {
    [setReminderSwitch setOn:YES];
    [setReminderSwitch_statement setOn:YES];
    SetReminderViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SetReminder"];
    if ([resultDict objectForKey:@"FrequencyId"] != nil)
        controller.defaultSettingsDict = resultDict;
    controller.reminderDelegate = self;
    controller.view.backgroundColor = [UIColor clearColor];
    controller.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:controller animated:YES completion:nil];
    
}
- (IBAction)selectSongButtonTapped:(id)sender {
    //    SongListViewController *songController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SongListView"];
    //    songController.songListDelegate = self;
    
    SongPlayListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PlayListView"];
    controller.isSelectMusic = YES;
    controller.delegate = self;
    [self presentViewController:controller animated:YES completion:nil];    //ah song
}
- (IBAction)showButtonPressed:(UIButton *)sender {

}

- (IBAction)deleteImagePressed:(UIButton *)sender {
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:nil
                                          message:@"Do you want to delete this image ?"
                                          preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:@"Yes"
                               style:UIAlertActionStyleDestructive
                               handler:^(UIAlertAction *action)
                               {
                                    if(![Utility isEmptyCheck:self->localImageName]){
                                        [Utility removeImage:self->localImageName];
                                    }
                                   //NSDictionary *dict = [self->imageArray objectAtIndex:0];
                                   //[self deleteVisionBoardImage:[dict objectForKey:@"GoalVisionBoardImgId"]];
//                                   [self->imageCollectionView reloadData];
                               }];
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:@"No"
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {
                                       
                                   }];
    [alertController addAction:okAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)toggleBoardStatementPressed:(UIButton *)sender
{
    if (sender.isSelected) {
        return;
    }
//    if ([Utility isEmptyCheck:_visionBoardDict]) {
//        //
//        [Utility msg:@"Please create vision board first." title:nil controller:self haveToPop:NO];
//        return;
//    }
    
    editRow = -1;
    
    
    if (sender == boardButton) {
        boardButton.selected = true;
        statementButton.selected = false;
        statementTable.hidden = true;
        statementReminderView.hidden=true;
        notificationView.hidden = true;
        visionStatementDtBtn.hidden = true;
        visionStatementView.hidden = true;
        printButton.hidden=true;
        if (![Utility isEmptyCheck:[_visionBoardDict objectForKey:@"GoalVisionBoardImagesModelList"]]) {
            visionImageView.hidden = false;
        }else{
//            visionImageView.hidden = true;
        }
      
    } else {
        boardButton.selected = false;
        statementButton.selected = true;
        statementTable.hidden = false;
        statementReminderView.hidden=true;
        notificationView.hidden = false;
        visionStatementDtBtn.hidden = false;
        visionStatementView.hidden = false;
        printButton.hidden=false;
        visionStatementView.backgroundColor = UIColor.whiteColor;
        if (![Utility isEmptyCheck:statementList]) {
            //
         
        }
        [statementTable reloadData];
        [self visionStatementDateView];
    }
    [self setSaveButton];

}
- (IBAction)alarmButtonPressed:(UIButton *)sender {
    if (![sender isSelected]) {
        SetReminderViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SetReminder"];
        if ([_visionBoardDict objectForKey:@"FrequencyId"] != nil)
            controller.defaultSettingsDict = _visionBoardDict;
        controller.reminderDelegate = self;
        //gami_badge_popup
        if (isFirstTimeReminderSet) {
            controller.isFirstTime = isFirstTimeReminderSet;
            isFirstTimeReminderSet = false;
        }//gami_badge_popup
        controller.view.backgroundColor = [UIColor clearColor];
        controller.modalPresentationStyle = UIModalPresentationCustom;
        [self presentViewController:controller animated:YES completion:nil];
    } else {
      
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:nil
                                              message:nil
                                              preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:@"Edit Reminder"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       SetReminderViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SetReminder"];
                                       if ([self->_visionBoardDict objectForKey:@"FrequencyId"] != nil)
                                           controller.defaultSettingsDict = self->_visionBoardDict;
                                       controller.reminderDelegate = self;
                                       controller.view.backgroundColor = [UIColor clearColor];
                                       controller.modalPresentationStyle = UIModalPresentationCustom;
                                       [self presentViewController:controller animated:YES completion:nil];
                                   }];
        UIAlertAction *turnOff = [UIAlertAction
                                  actionWithTitle:@"Turn Off Reminder"
                                  style:UIAlertActionStyleDefault
                                  handler:^(UIAlertAction *action)
                                  {
                                      
                                      self->alarmButton.selected = false;
                                      NSArray *requests = [[UIApplication sharedApplication] scheduledLocalNotifications];
                                      for (UILocalNotification *req in requests) {
                                          NSString *pushTo = [req.userInfo objectForKey:@"pushTo"];
                                          if ([pushTo caseInsensitiveCompare:@"Vision"] == NSOrderedSame) {
                                              [[UIApplication sharedApplication] cancelLocalNotification:req];
                                          }
                                      }
                                      [self->_visionBoardDict removeObjectForKey:@"FrequencyId"];
                                      [self saveDataWithMultipart];
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
    }
    
}
- (IBAction)editStatementPressed:(UIButton *)sender{
    editRow = (int)sender.tag;
    //    saveView.hidden = false;
    //    [statementTable reloadData];
    VisionGoalActionTableViewCell *vCell;
    @try {
        NSIndexPath *mIndex = [NSIndexPath indexPathForRow:editRow inSection:0];
        vCell = (VisionGoalActionTableViewCell *)[statementTable cellForRowAtIndexPath:mIndex];
    } @catch (NSException *exception) {
        
    }
    if (!vCell) {
        vCell = [[VisionGoalActionTableViewCell alloc]init];
    }
    vCell.editView.hidden = true;
    [vCell.statementTextView becomeFirstResponder];
}
#pragma mark - API call
- (void)getData{
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!self->contentView || ![self->contentView isDescendantOfView:self.view]) {
                self->contentView = [Utility activityIndicatorView:self];     //ah cv
            }
        });
        NSURLSession *achieveSession = [NSURLSession sharedSession];
        
        NSError *error;
        
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults objectForKey:@"UserID"] forKey:@"UserID"];
        [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetVisionBoardAPI" append:@"" forAction:@"POST"];
        
        NSURLSessionDataTask * dataTask =[achieveSession dataTaskWithRequest:request
                                                           completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                               dispatch_async(dispatch_get_main_queue(),^ {
                                                                   if (self->contentView) {
                                                                       [self->contentView removeFromSuperview];   //ah cv
                                                                   }
                                                                   if(error == nil)
                                                                   {
                                                                       NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                       NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                       
                                                                       if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDictionary] && [[responseDictionary objectForKey:@"SuccessFlag"] boolValue]) {
                                                                           //self->isEdit = false;
                                                                           self->_visionBoardDict = [[responseDictionary objectForKey:@"Details"]mutableCopy];
                                                                           NSArray *arr = [self->_visionBoardDict objectForKey:@"GoalVisionBoardImagesModelList"];
                                                                           if (![Utility isEmptyCheck:arr]) {
                                                                               [self->imageArray addObjectsFromArray:arr];
                                                                           }
                                                                           [self prepareView];
                                                                       }
                                                                   } else{
                                                                       [Utility msg:error.localizedDescription title:@"Error !" controller:self haveToPop:NO];
                                                                   }
                                                                   
                                                                   [self goalVisionBoardStatementList];
                                                               });
                                                           }];
        [dataTask resume];
        
    }else{
        [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
    }
 
}
-(void) saveData {
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
            self->contentView = [Utility activityIndicatorView:self];
        });
        NSURLSession *achieveSession = [NSURLSession sharedSession];
        
        if ([resultDict objectForKey:@"FrequencyId"] == nil) {
            [resultDict setObject:[NSNumber numberWithInt:1] forKey:@"FrequencyId"];
            [resultDict setObject:[NSNumber numberWithInt:1] forKey:@"MonthReminder"];
            [resultDict setObject:[NSNumber numberWithInt:43200] forKey:@"ReminderAt1"];
            [resultDict setObject:[NSNumber numberWithInt:43200] forKey:@"ReminderAt2"];
            [resultDict setObject:[NSNumber numberWithInt:1] forKey:@"ReminderOption"];
            [resultDict setObject:[NSNumber numberWithBool:false] forKey:@"PushNotification"];
            [resultDict setObject:[NSNumber numberWithBool:false] forKey:@"Email"];
            
            NSDateFormatter *newDateformatter = [[NSDateFormatter alloc]init];
            NSArray* monthArray = [newDateformatter monthSymbols];
            NSArray* dayArray = [newDateformatter weekdaySymbols];
            for (int i = 0; i < monthArray.count; i++) {
                [resultDict setObject:[NSNumber numberWithBool:false] forKey:[monthArray objectAtIndex:i]];
            }
            for (int i = 0; i < dayArray.count; i++) {
                [resultDict setObject:[NSNumber numberWithBool:false] forKey:[dayArray objectAtIndex:i]];
            }
        }
        
        if (![Utility isEmptyCheck:chosenImage]) {
            NSString *imgBase64Str = [UIImagePNGRepresentation(chosenImage) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
            NSLog(@"img %@",imgBase64Str);
            [resultDict setObject:imgBase64Str forKey:@"UploadVisionBoardImgBase64Image"];
        }
        
        NSString *html = visionText;
        NSLog(@"html: %@",html);
        NSLog(@"html2: %@",[resultDict objectForKey:@"OnThisDateIwillLook"]);
        if (![Utility isEmptyCheck:[resultDict objectForKey:@"OnThisDateIwillLook"]]) {
            NSString *html1 = [[resultDict objectForKey:@"OnThisDateIwillLook"] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
            [resultDict setObject:html1 forKey:@"OnThisDateIwillLook"];
        }
        

        NSLog(@"html3: %@",[resultDict objectForKey:@"OnThisDateIwillLook"]);
        // [resultDict setObject:@"" forKey:@"OnThisDateIwillLook"];
        NSError *error;
        
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:resultDict forKey:@"model"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"AddUpdateVisionBoardAPI" append:@"" forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[achieveSession dataTaskWithRequest:request
                                                           completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                               dispatch_async(dispatch_get_main_queue(),^ {
                                                                   if (self->contentView) {
                                                                       [self->contentView removeFromSuperview];
                                                                   }
                                                                   if(error == nil)
                                                                   {
                                                                       NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                       NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                       if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDictionary] && [[responseDictionary objectForKey:@"SuccessFlag"] boolValue]) {
                                                                    
                                                                           [self dismissViewControllerAnimated:YES completion:nil];
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
        
    }else{
        [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
    }
    
}

-(void) saveDataWithMultipart {
    if (Utility.reachable) {
        if ([resultDict objectForKey:@"FrequencyId"] == nil) {
            [resultDict setObject:[NSNumber numberWithInt:1] forKey:@"FrequencyId"];
            [resultDict setObject:[NSNumber numberWithInt:1] forKey:@"MonthReminder"];
            [resultDict setObject:[NSNumber numberWithInt:12] forKey:@"ReminderAt1"];
            [resultDict setObject:[NSNumber numberWithInt:12] forKey:@"ReminderAt2"];
            [resultDict setObject:[NSNumber numberWithInt:1] forKey:@"ReminderOption"];
            [resultDict setObject:[NSNumber numberWithBool:false] forKey:@"PushNotification"];
            [resultDict setObject:[NSNumber numberWithBool:false] forKey:@"Email"];
            
            NSDateFormatter *newDateformatter = [[NSDateFormatter alloc]init];
            NSArray* monthArray = [newDateformatter monthSymbols];
            NSArray* dayArray = [newDateformatter weekdaySymbols];
            for (int i = 0; i < monthArray.count; i++) {
                [resultDict setObject:[NSNumber numberWithBool:false] forKey:[monthArray objectAtIndex:i]];
            }
            for (int i = 0; i < dayArray.count; i++) {
                [resultDict setObject:[NSNumber numberWithBool:false] forKey:[dayArray objectAtIndex:i]];
            }
        }
        NSString *html = visionText;
        NSLog(@"html: %@",html);
        if (![Utility isEmptyCheck:html]) {
            [resultDict setObject:html forKey:@"OnThisDateIwillLook"];
        }
        
        if(![Utility isEmptyCheck:localImageName]){
            [resultDict setObject:localImageName forKey:@"BoardImageDevicePath"];
        }else{
            [resultDict setObject:@"" forKey:@"BoardImageDevicePath"];
        }
        
        
        if (![Utility isEmptyCheck:[resultDict objectForKey:@"OnThisDateIwillLook"]]) {
            NSString *html1 = [[resultDict objectForKey:@"OnThisDateIwillLook"] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
            [resultDict setObject:html1 forKey:@"OnThisDateIwillLook"];
        }
        NSLog(@"html3: %@",[resultDict objectForKey:@"OnThisDateIwillLook"]);
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:resultDict forKey:@"model"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSMutableDictionary *imgDict = [NSMutableDictionary new];

        if (chosenImage) {
            //[imgDict setObject:chosenImage forKey:@"image"];
            
        }
        
        
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        NSLog(@"%@",jsonString);
        ProgressBarViewController *controller=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ProgressBar"];
        controller.delegate=self;
        controller.apiName=@"AddUpdateVisionBoardWithPhoto";
        controller.isMultiImage=YES;
        controller.appendString=@"";
        controller.jsonString=jsonString;
        controller.imageDataDict=imgDict;//[NSDictionary dictionaryWithObjectsAndKeys:UIImagePNGRepresentation(chosenImage),@"image0", nil];
        
        controller.modalPresentationStyle = UIModalPresentationCustom;
        [self presentViewController:controller animated:YES completion:nil];
    }
    else{
        [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
    }
    
}
-(void)deleteVisionBoardImage:(NSNumber *)GoalVisionBoardImgId{
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!self->contentView || ![self->contentView isDescendantOfView:self.view]) {
                self->contentView = [Utility activityIndicatorView:self];
            }
        });
        NSURLSession *achieveSession = [NSURLSession sharedSession];
        
        NSError *error;
        
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults objectForKey:@"UserID"] forKey:@"UserID"];
        [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:GoalVisionBoardImgId forKey:@"id"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"DeleteVisionBoardImage" append:@"" forAction:@"POST"];
        
        NSURLSessionDataTask * dataTask =[achieveSession dataTaskWithRequest:request
                                                           completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                               dispatch_async(dispatch_get_main_queue(),^ {
                                                                   if (self->contentView) {
                                                                       [self->contentView removeFromSuperview];   //ah cv
                                                                   }
                                                                   if(error == nil)
                                                                   {
                                                                       NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                       NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                       
                                                                       if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDictionary] && [[responseDictionary objectForKey:@"SuccessFlag"] boolValue]) {
                                                                           [self->imageArray removeObjectAtIndex:self->imageArray.count-1];
                                                                           [self->_visionBoardDict setObject:self->imageArray forKey:@"GoalVisionBoardImagesModelList"];
                                                                           [self prepareView];
                                                                       }else{
                                                                           [Utility msg:[responseDictionary objectForKey:@"ErrorMessage"] title:@"Error !" controller:self haveToPop:NO];
                                                                           return;
                                                                       }
                                                                   } else {
                                                                       [Utility msg:error.localizedDescription title:@"Error !" controller:self haveToPop:NO];
                                                                   }
                                                               });
                                                           }];
        [dataTask resume];
        
    }else{
        [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
    }
}

/////MBHQ
-(void)goalVisionBoardStatementList{
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
            self->contentView = [Utility activityIndicatorView:self];
        });
        NSURLSession *achieveSession = [NSURLSession sharedSession];
        
        NSError *error;
        
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults objectForKey:@"UserID"] forKey:@"UserID"];
        [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetVisionBoardStatementImages" append:@"" forAction:@"POST"];
        
        NSURLSessionDataTask * dataTask =[achieveSession dataTaskWithRequest:request
                                                           completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                               dispatch_async(dispatch_get_main_queue(),^ {
                                                                   if (self->contentView) {
                                                                       [self->contentView removeFromSuperview];
                                                                   }
                                                                   if(error == nil)
                                                                   {
                                                                       NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                       NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                       
                                                                       if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDictionary] && [[responseDictionary objectForKey:@"SuccessFlag"] boolValue]) {
                                                                           
                                                                           self->statementList = [[responseDictionary objectForKey:@"StatementImages"]mutableCopy];
                                                                           
                                                                           if ([Utility isEmptyCheck:self->statementList]) {
                                                                               NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
//                                                                               [dict setObject:[NSNumber numberWithInt:-1] forKey:@"VisionImagesStatementId"];
//                                                                               [dict setObject:@"" forKey:@"GoalVisionBoardId"];
                                                                               [dict setObject:@"" forKey:@"PictureTitle"];
                                                                               [dict setObject:@"" forKey:@"PictureUrl"];
                                                                               [dict setObject:@"" forKey:@"PictureDevicePath"];
                                                                               [dict setObject:@"" forKey:@"FutureMe"];
                                                                               [dict setObject:@"" forKey:@"LiveItNow"];
                                                                               
                                                                               for (int i=0; i<10; i++) {
                                                                                   [self->statementList addObject:dict];
                                                                               }
                                                                           }
                                                                           
                                                                           [self->statementTable reloadData];
                                                                            [self visionStatementDateView];
                                                                           
                                                                       } else {
                                                                           [Utility msg:[responseDictionary objectForKey:@"ErrorMessage"] title:@"Error !" controller:self haveToPop:NO];
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
-(void)webServicecallForEmailGoalVisionBoardStatementList{
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
            self->contentView = [Utility activityIndicatorView:self];
        });
        NSURLSession *achieveSession = [NSURLSession sharedSession];
        
        NSError *error;
        
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults objectForKey:@"UserID"] forKey:@"UserID"];
        [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"EmailGoalVisionBoardStatementList" append:@"" forAction:@"POST"];
        
        NSURLSessionDataTask * dataTask =[achieveSession dataTaskWithRequest:request
                                                           completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                               dispatch_async(dispatch_get_main_queue(),^ {
                                                                   if (self->contentView) {
                                                                       [self->contentView removeFromSuperview];
                                                                   }
                                                                   if(error == nil)
                                                                   {
                                                                       NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

                                                                       NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                       if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDictionary] && [[responseDictionary objectForKey:@"SuccessFlag"] boolValue]) {
                                                                           [Utility msg:@"Future details sent to mail" title:@"" controller:self haveToPop:NO];
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
-(void)updateVisionBoardStatement{
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
            self->contentView = [Utility activityIndicatorView:self];
        });
        NSURLSession *achieveSession = [NSURLSession sharedSession];
        
        NSError *error;
        
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults objectForKey:@"UserID"] forKey:@"UserID"];
        [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:statementList forKey:@"StatementImages"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"AddUpdateVisionBoardStatementImage" append:@"" forAction:@"POST"];
        
        NSURLSessionDataTask * dataTask =[achieveSession dataTaskWithRequest:request
                                                           completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                               dispatch_async(dispatch_get_main_queue(),^ {
                                                                   if (self->contentView) {
                                                                       [self->contentView removeFromSuperview];
                                                                   }
                                                                   if(error == nil)
                                                                   {
                                                                       
                                                                       NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                       NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                       
                                                                       if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDictionary] && [[responseDictionary objectForKey:@"SuccessFlag"] boolValue]) {
                                                                          // self->isEdit = false;
                                                                           self->editRow = -1;
                                                                           
                                                                           self->isStatementEdited=NO;
                                                                           [self setSaveButton];
                                                                           
                                                                           [self goalVisionBoardStatementList];
                                                                           
                                                                       } else {
                                                                           [Utility msg:[responseDictionary objectForKey:@"ErrorMessage"] title:@"Error !" controller:self haveToPop:NO];
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

//visionBoardDict
//RU
#pragma mark - UITableView DataSource & Delegate

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return statementList.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    VisionGoalActionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VisionGoalActionTableViewCell" forIndexPath:indexPath];
    
    if (![Utility isEmptyCheck:statementList]) {
        NSDictionary *dict = [statementList objectAtIndex:indexPath.row];
        if (![Utility isEmptyCheck:dict]) {
            
//            cell.statementLabel.text = [@"" stringByAppendingFormat:@"%@",![Utility isEmptyCheck:[dict objectForKey:@"statement"]]?[@"" stringByAppendingFormat:@"%@:",[dict objectForKey:@"statement"]]:@""];
//           cell.pictureTitleTextView.inputAccessoryView = numberToolbar;

            cell.pictureTitleLabel.text = [@"" stringByAppendingFormat:@"%@",![Utility isEmptyCheck:[dict objectForKey:@"PictureTitle"]]?[dict objectForKey:@"PictureTitle"]:@""];
//            cell.pictureTitleLabel.textColor = [[Utility colorWithHexString:@"333333"]colorWithAlphaComponent:1];
            cell.pictureTitleLabel.tag = indexPath.row;
            cell.pictureTitleLabel.accessibilityHint=@"PictureTitle";
            cell.pictureTitleLabel_btn.tag = indexPath.row;
            cell.pictureTitleLabel_btn.accessibilityHint=@"PictureTitle";
        
            
            cell.futureMeLabel.text = [@"" stringByAppendingFormat:@"%@",![Utility isEmptyCheck:[dict objectForKey:@"FutureMe"]]?[dict objectForKey:@"FutureMe"]:@""];
//            cell.futureMeLabel.textColor = [[Utility colorWithHexString:@"333333"]colorWithAlphaComponent:1];
            cell.futureMeLabel.tag = indexPath.row;
            cell.futureMeLabel.accessibilityHint=@"FutureMe";
            cell.futureMeLabel_btn.tag = indexPath.row;
            cell.futureMeLabel_btn.accessibilityHint=@"FutureMe";
            
            cell.liveItNowLabel.text = [@"" stringByAppendingFormat:@"%@",![Utility isEmptyCheck:[dict objectForKey:@"LiveItNow"]]?[dict objectForKey:@"LiveItNow"]:@""];
//            cell.liveItNowLabel.textColor = [[Utility colorWithHexString:@"333333"]colorWithAlphaComponent:1];
            cell.liveItNowLabel.tag = indexPath.row;
            cell.liveItNowLabel.accessibilityHint=@"LiveItNow";
            cell.liveItNowLabel_btn.tag = indexPath.row;
            cell.liveItNowLabel_btn.accessibilityHint=@"LiveItNow";
            
        }
    }
    return cell;
}

//-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//
//    NSDictionary *dict = [statementList objectAtIndex:indexPath.row];
//    NSString *text = [@"" stringByAppendingFormat:@"%@",![Utility isEmptyCheck:[dict objectForKey:@"Answer"]]?[dict objectForKey:@"Answer"]:@""];
//
//    NotesViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NotesView"];
//    controller.visionStatementIndex=indexPath.row;
//    controller.notesDelegate=self;
//    controller.fromStr=@"VisionStatement";
//    controller.visionStatementText=text;
//    [self presentViewController:controller animated:YES completion:nil];
//
//
//}


#pragma mark - End
#pragma mark - CollectionView DataSource & Delegate
/*not in use*/
- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 0;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat width = 0;
    CGFloat height = 0;
 
    return CGSizeMake(width, height);
}
- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    VisionCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"VisionCollectionViewCell" forIndexPath:indexPath];
    
    NSArray *imageArray = [_visionBoardDict objectForKey:@"GoalVisionBoardImagesModelList"];
    if (![Utility isEmptyCheck:imageArray]) {
        NSDictionary *imgDict = [imageArray objectAtIndex:indexPath.row];
        [cell.visionImage sd_setImageWithURL:[NSURL URLWithString:[imgDict objectForKey:@"BoardImage"]] placeholderImage:[UIImage imageNamed:@"upload_image.png"] options:SDWebImageScaleDownLargeImages];
     
        cell.deleteButton.hidden = !isEdit;
        cell.deleteButton.tag = [[imgDict objectForKey:@"GoalVisionBoardImgId"]intValue];
    }
    
    return cell;
}
#pragma mark - End

#pragma mark - textView Delegate

- (void)textViewDidBeginEditing:(UITextView *)textView{
//    activeTextView=textView;
//    editRow = (int)textView.tag;
//    [textView setScrollEnabled:YES];
    NSDictionary *dict = [statementList objectAtIndex:textView.tag];
    
    NSString *text = [@"" stringByAppendingFormat:@"%@",![Utility isEmptyCheck:[dict objectForKey:textView.accessibilityHint]]?[dict objectForKey:textView.accessibilityHint]:@""];
    
    NotesViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NotesView"];
    controller.visionStatementIndex=textView.tag;
    controller.visionStatementKey=textView.accessibilityHint;
    controller.notesDelegate=self;
    controller.fromStr=@"VisionStatement";
    controller.visionStatementText=text;
    [textView resignFirstResponder];
    [self.navigationController pushViewController:controller animated:NO];
//    [self presentViewController:controller animated:YES completion:nil];
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    activeTextView=nil;
    NSMutableDictionary *dict = [[statementList objectAtIndex:textView.tag]mutableCopy];
    [dict setObject:textView.text forKey:textView.accessibilityHint];
    [statementList replaceObjectAtIndex:textView.tag withObject:dict];
    if (textView.text.length>0) {
    }
    if(textView.text.length>0){
        [textView setScrollEnabled:NO];
        [textView sizeToFit];
    }
    if(self->editRow>=0){
        int index = self->editRow;
        self->editRow = -1;
        [statementTable reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }
    
    [textView resignFirstResponder];
}

#pragma mark - KeyboardNotifications -
// Call this method somewhere in your view controller setup code.
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

    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height-155+45,0.0);
    statementTable.contentInset = contentInsets;
    statementTable.scrollIndicatorInsets = contentInsets;
    
    if (activeTextView !=nil) {
        CGRect aRect = statementTable.frame;
        CGRect frame = [statementTable convertRect:activeTextView.frame fromView:activeTextView];
        CGFloat height = kbSize.height + 100;
        aRect.size.height -= height;
        if (!CGRectContainsPoint(aRect, frame.origin) ) {
            [statementTable scrollRectToVisible:frame animated:YES];
        }
    }
}


// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    statementTable.contentInset = contentInsets;
    statementTable.scrollIndicatorInsets = contentInsets;
}
#pragma mark - End
#pragma mark - ReminderDelegate
-(void) reminderSettingsValue:(NSMutableDictionary *)reminderDict {
  NSLog(@"rem %@",reminderDict);
//    isChanged=YES;
    isStatementEdited=YES;
    isVisionEdited=YES;
    [self setSaveButton];
    
    [self->_visionBoardDict addEntriesFromDictionary:reminderDict];
    savedReminderDict = reminderDict;   //ah ln1
    [resultDict addEntriesFromDictionary:reminderDict];
    
    self->alarmButton.selected = true;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateBadgePoint" object:self];//gami_badge_popup
    
    NSArray *requests = [[UIApplication sharedApplication] scheduledLocalNotifications];
    for (UILocalNotification *req in requests) {
        NSString *pushTo = [req.userInfo objectForKey:@"pushTo"];
        if ([pushTo caseInsensitiveCompare:@"Vision"] == NSOrderedSame) {
            [[UIApplication sharedApplication] cancelLocalNotification:req];
        }
    }
    if ([[self->_visionBoardDict objectForKey:@"PushNotification"] boolValue])
        [SetReminderViewController setOldLocalNotificationFromDictionary:self->_visionBoardDict ExtraData:[NSMutableDictionary new] FromController:@"Vision" Title:@"MBHQ" Type:@"Vision" Id:0];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self saveDataWithMultipart];
    });
}
-(void) cancelReminder {
    if ([resultDict objectForKey:@"FrequencyId"] != nil) {
        
    } else {
        [setReminderSwitch setOn:NO];
        [setReminderSwitch_statement setOn:NO];
        [resultDict removeObjectForKey:@"FrequencyId"];
    }
    [self prepareReminderView];
}
#pragma  mark - DatePickerViewControllerDelegate

-(void)didSelectDate:(NSDate *)date withSenderObject:(id)sender{
//    isChanged = YES;
    isVisionEdited=YES;
    [self setSaveButton];
    
    UIButton *button = (UIButton*)sender;
    
    if(button == visionDateButton){
        
        static NSDateFormatter *dateFormatter;
        dateFormatter = [NSDateFormatter new];
        // [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
        selectedDate = date;
        [dateFormatter setDateFormat:@"dd/MM/yyyy"];
        NSString *dateString = [dateFormatter stringFromDate:date];
        [visionDateButton setTitle:dateString forState:UIControlStateNormal];
        
        //        NSCalendar *cal = [NSCalendar currentCalendar];
        //        NSDate *newDate = [cal dateByAddingUnit:NSCalendarUnitMonth value:1 toDate:[NSDate date] options:0];
        //        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
        NSString *currentDateStr = [dateFormatter stringFromDate:date];
        [resultDict setObject:currentDateStr forKey:@"VisionDate"];
        [_visionBoardDict setObject:currentDateStr forKey:@"VisionDate"];
        
    }else{
        if (date)
        {
            static NSDateFormatter *dateFormatter;
            dateFormatter = [NSDateFormatter new];
            
            [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
            NSString *currentDateStr = [dateFormatter stringFromDate:date];
            [_visionBoardDict setObject:currentDateStr forKey:@"VisionDate"];
            [statementTable reloadData];
            [self visionStatementDateView];
            [self saveDataWithMultipart];
           
        }
    }
    
   
}
#pragma mark - AddVisionEntryDelegate
-(void) addVisionEntryFromString:(NSString *)text {
    dispatch_async(dispatch_get_main_queue(),^ {
//        self->isChanged = YES;
        self->isVisionEdited=YES;
        [self setSaveButton];
        
       
    });
    visionText = text;
    visionLabel.attributedText = [Utility htmlParseWithString:text];
    [_visionBoardDict setObject:text forKey:@"OnThisDateIwillLook"];
}
#pragma mark - SongListDelegate
- (void) getSelectedSongName:(NSString *)name Url:(NSString *)songUrlStr {
    NSLog(@"su %@",songUrlStr);
   
//    isChanged = YES;
    isVisionEdited=YES;
    [self setSaveButton];
    
    [selectSongButton setAccessibilityHint:songUrlStr];
    [selectSongButton setTitle:name forState:UIControlStateNormal];
    NSString *saveSongDataStr = [NSString stringWithFormat:@"%@*##*%@",songUrlStr,name];
    [resultDict setObject:saveSongDataStr forKey:@"Song"];      //ah 4.5
    
}
#pragma mark - SportifyDelegate
-(void) sportifySelSongName:(NSString *)name Url:(NSString *)songUrlStr{
    //song name from spotify
    NSLog(@"song song song %@",songUrlStr);
    
//    isChanged = YES;
    isVisionEdited=YES;
    [self setSaveButton];
    
    [selectSongButton setAccessibilityHint:songUrlStr];
    [selectSongButton setTitle:name forState:UIControlStateNormal];
    NSString *saveSongDataStr = [NSString stringWithFormat:@"%@*##*%@",songUrlStr,name];
    [resultDict setObject:saveSongDataStr forKey:@"Song"];      //ah 4.5
    [_visionBoardDict setObject:saveSongDataStr forKey:@"Song"];
    [self playSongInSpotify:songUrlStr];
}
-(void)playSongInSpotify:(NSString *)songUrlStr{
    @try {
        SPTAuth *auth = [SPTAuth defaultInstance];
        NSLog(@"%@",auth.session);
        if (![Utility isEmptyCheck:auth.session]) {
            if (auth.session.isValid) {
                if (self.sPlayer == nil) {
                    NSError *error = nil;
                    NSLog(@"%@\n%@",auth.clientID,auth.session.accessToken);
                    if(![Utility isEmptyCheck:auth.clientID] && ![Utility isEmptyCheck:auth.session.accessToken]){
                        self.sPlayer = [SPTAudioStreamingController sharedInstance];
                        if (!self.sPlayer.initialized) {
                            if ([self.sPlayer startWithClientId:auth.clientID audioController:nil allowCaching:YES error:&error]) {
                                self.sPlayer.delegate = self;
                                self.sPlayer.playbackDelegate = self;
                                self.sPlayer.diskCache = [[SPTDiskCache alloc] initWithCapacity:1024 * 1024 * 64];
                                [self.sPlayer loginWithAccessToken:auth.session.accessToken];
                            }
                            
                        }
                        
                    }
                    
                }
            }
        }
        

        if (self.sPlayer.playbackState.isPlaying) {
            [self.sPlayer setIsPlaying:NO callback:nil];
        }
        [self.sPlayer playSpotifyURI:songUrlStr startingWithIndex:0 startingWithPosition:10 callback:^(NSError *error) {
            if (error != nil) {
                NSLog(@"*** failed to play: %@", error);
                return;
            }else{
                
            }
        }];
    } @catch (NSException *exception) {
        
    }
}
#pragma mark - Private Methods

-(void)setSaveButton{
    if (isVisionEdited && boardButton.isSelected ) {
        saveButton.layer.borderColor = [UIColor colorWithRed:50.0 / 255.0 green:205.0 / 255.0 blue:184.0 / 255.0 alpha:1.0].CGColor;
        [saveButton setBackgroundColor:[UIColor colorWithRed:50.0 / 255.0 green:205.0 / 255.0 blue:184.0 / 255.0 alpha:1.0]];
    }else if (isStatementEdited && statementButton.isSelected){
        saveButton.layer.borderColor = [UIColor colorWithRed:50.0 / 255.0 green:205.0 / 255.0 blue:184.0 / 255.0 alpha:1.0].CGColor;
        [saveButton setBackgroundColor:[UIColor colorWithRed:50.0 / 255.0 green:205.0 / 255.0 blue:184.0 / 255.0 alpha:1.0]];
    }else{
        saveButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [saveButton setBackgroundColor:[UIColor lightGrayColor]];
    }
}



-(void)doneWithFirstResponder{
    [self.view endEditing:YES];
}
-(BOOL) validationCheck {
    BOOL isValid = NO;
    if ([Utility isEmptyCheck:visionText]) {
        [Utility msg:@"Please enter some text for vision board." title:@"Oops!" controller:self haveToPop:NO];
        return isValid;
    }
   
    return YES;
}
-(void)openPhotoAlbum{

    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    controller.delegate = self;
    controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:controller animated:YES completion:NULL];
}
-(void)showCamera{
    if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) return;
    
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    controller.delegate = self;
    controller.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:controller animated:YES completion:NULL];
}

-(void)prepareView
{
    
    [addEditImageBtn setTitleColor:[UIColor colorWithRed:50.0 / 255.0 green:205.0 / 255.0 blue:184.0 / 255.0 alpha:1.0] forState:UIControlStateNormal];
       addEditImageBtn.backgroundColor = [UIColor whiteColor];
       [addEditImageBtn setTitle:@"ADD IMAGE" forState:UIControlStateNormal];
       visionImageView.hidden = YES;
       visionDateView.hidden = NO;
       visionReminderView.hidden = NO;
       songView.hidden = NO;
       saveButton.hidden = NO;
        //////
       lastView.hidden = YES;
       backButton.hidden = NO;
    [setReminderSwitch setOn:NO];
    [setReminderSwitch_statement setOn:NO];
    
    
    if (![Utility isEmptyCheck:_visionBoardDict] && _visionBoardDict.count > 0) {
      //////RU
   // [addEditImageBtn setTitleColor:[UIColor colorWithRed:20.0 / 255.0 green:227.0 / 255.0 blue:209.0 / 255.0 alpha:1.0] forState:UIControlStateNormal];
   
        
    
   if(![Utility isEmptyCheck:[_visionBoardDict objectForKey:@"BoardImageDevicePath"]]){
            localImageName = [_visionBoardDict objectForKey:@"BoardImageDevicePath"];
            UIImage *selectedImage = [Utility getImageFromDocumentDirectoryWithImageName:localImageName];
            
            if(selectedImage){
                [addEditImageBtn setTitle:@"CHANGE IMAGE" forState:UIControlStateNormal];
                visionImageView.image=selectedImage;
                visionImageView.hidden = false;
                uploadImageButton.hidden = true;
                changePicView.hidden = false;
                CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
                CGFloat imageViewHeight = selectedImage.size.height/selectedImage.size.width * screenWidth;
                self->visionImageViewHeight.constant = imageViewHeight;
                [self.view setNeedsUpdateConstraints];
            }else if (![Utility isEmptyCheck:[_visionBoardDict objectForKey:@"GoalVisionBoardImagesModelList"]]) {
                NSArray *arr = [_visionBoardDict objectForKey:@"GoalVisionBoardImagesModelList"];
                [visionImageView sd_setImageWithURL:[NSURL URLWithString:[[arr objectAtIndex:arr.count-1]objectForKey:@"BoardImage"]] placeholderImage:[UIImage imageNamed:@"img_holder.png"] options:SDWebImageScaleDownLargeImages completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (image) {
                            CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
                            CGFloat imageViewHeight = image.size.height/image.size.width * screenWidth;
                            self->visionImageViewHeight.constant = imageViewHeight;
                            [self.view setNeedsUpdateConstraints];
                        }
                    });
                    
                }];
                visionImageView.hidden = false;
                uploadImageButton.hidden = true;
                changePicView.hidden = false;
            } else{
                visionImageView.hidden = true;
                addEditImageBtn.backgroundColor = [UIColor colorWithRed:50.0 / 255.0 green:205.0 / 255.0 blue:184.0 / 255.0 alpha:1.0];
                [addEditImageBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [addEditImageBtn setTitle:@"ADD IMAGE" forState:UIControlStateNormal];
                visionImageView.image=[UIImage imageNamed:@"upload_image.png"];
                uploadImageButton.hidden = false;
            }
            
            
   }else if (![Utility isEmptyCheck:[_visionBoardDict objectForKey:@"GoalVisionBoardImagesModelList"]]) {
       NSArray *arr = [_visionBoardDict objectForKey:@"GoalVisionBoardImagesModelList"];
       [visionImageView sd_setImageWithURL:[NSURL URLWithString:[[arr objectAtIndex:arr.count-1]objectForKey:@"BoardImage"]] placeholderImage:[UIImage imageNamed:@"img_holder.png"] options:SDWebImageScaleDownLargeImages completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            dispatch_async(dispatch_get_main_queue(), ^{
              if (image) {
                  CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
                  CGFloat imageViewHeight = image.size.height/image.size.width * screenWidth;
                  self->visionImageViewHeight.constant = imageViewHeight;
                  [self.view setNeedsUpdateConstraints];
              }
          });
       }];
       visionImageView.hidden = false;
       uploadImageButton.hidden = true;
       changePicView.hidden = false;
       
   }else{
        visionImageView.hidden = true;
        addEditImageBtn.backgroundColor = [UIColor colorWithRed:50.0 / 255.0 green:205.0 / 255.0 blue:184.0 / 255.0 alpha:1.0];
        [addEditImageBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [addEditImageBtn setTitle:@"ADD IMAGE" forState:UIControlStateNormal];
        visionImageView.image=[UIImage imageNamed:@"upload_image.png"];
        uploadImageButton.hidden = false;
        localImageName = [Utility createImageFileNameFromTimeStamp];
        
    }
    
   /* NSArray *arr = [_visionBoardDict objectForKey:@"GoalVisionBoardImagesModelList"];
    if (![Utility isEmptyCheck:arr]) {
        [visionImageView sd_setImageWithURL:[NSURL URLWithString:[[arr objectAtIndex:arr.count-1]objectForKey:@"BoardImage"]] placeholderImage:[UIImage imageNamed:@"EXERCISE-picture-coming.jpg"] options:SDWebImageScaleDownLargeImages completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image) {
                CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
                CGFloat imageViewHeight = image.size.height/image.size.width * screenWidth;
                self->visionImageViewHeight.constant = imageViewHeight;
                [self.view setNeedsUpdateConstraints];
            }
        }];
        visionImageView.hidden = false;
        uploadImageButton.hidden = true;
        changePicView.hidden = false;
    }
    else{
        addEditImageBtn.backgroundColor = [UIColor colorWithRed:50.0 / 255.0 green:205.0 / 255.0 blue:184.0 / 255.0 alpha:1.0];
        [addEditImageBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [addEditImageBtn setTitle:@"ADD IMAGE" forState:UIControlStateNormal];
        visionImageView.image=[UIImage imageNamed:@"upload_image.png"];
        uploadImageButton.hidden = false;
//        changePicView.hidden = true;
        }*/
        
    NSString *string = ![Utility isEmptyCheck:[_visionBoardDict objectForKey:@"OnThisDateIwillLook"]] ? [_visionBoardDict objectForKey:@"OnThisDateIwillLook"] : @"No vision statement";
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setAlignment:NSTextAlignmentCenter];
        
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
    attributedString = [[Utility htmlParseWithString:string] mutableCopy];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attributedString.length)];
        
    visionLabel.attributedText = attributedString;
        
    if (![Utility isEmptyCheck:[_visionBoardDict objectForKey:@"PushNotification"]] && ![Utility isEmptyCheck:[_visionBoardDict objectForKey:@"Email"]] && ([[_visionBoardDict objectForKey:@"PushNotification"] boolValue] || [[_visionBoardDict objectForKey:@"Email"] boolValue])) {
            savedReminderDict = _visionBoardDict;   //ah ln1
            [setReminderSwitch setOn:YES];
            [setReminderSwitch_statement setOn:YES];
    } else {
        [setReminderSwitch setOn:NO];
        [setReminderSwitch_statement setOn:NO];
    }
        
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSDate *visionDate;
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    if (![Utility isEmptyCheck:[_visionBoardDict objectForKey:@"VisionDate"]]) {
        visionDate = [formatter dateFromString:[_visionBoardDict objectForKey:@"VisionDate"]];
        selectedDate = visionDate;
    }
    [formatter setDateFormat:@"dd/MM/yyyy"];
    NSString *currentButtonDateStr = [formatter stringFromDate:visionDate];
    [visionDateButton setTitle:currentButtonDateStr forState:UIControlStateNormal];
        
    [resultDict addEntriesFromDictionary:_visionBoardDict];
        
    if (![Utility isEmptyCheck:[_visionBoardDict objectForKey:@"Song"]]) {
        
        NSError *error;
        NSArray *songArr = [[_visionBoardDict objectForKey:@"Song"] componentsSeparatedByString:@"*##*"];
            
        if (![Utility isEmptyCheck:songArr]) {
            if (songArr.count > 1) {
                [selectSongButton setTitle:[songArr objectAtIndex:1] forState:UIControlStateNormal];
            }
            NSString *uri = [songArr objectAtIndex:0];
            if ([uri hasPrefix:@"spotify"]) {
                [self playSongInSpotify:uri];
            }
            else
            {
            player = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL URLWithString:[songArr objectAtIndex:0]] error:&error];
                    
                if (!error) {
                    [player prepareToPlay];
                    [player play];
                }
            }
        }
    }
}

    
    [self prepareReminderView];
}

-(void)prepareReminderView{
    if (setReminderSwitch.on) {
        viewReminder.enabled = true;
        viewReminder.alpha = 1.0;
        
    }else{
        viewReminder.enabled = false;
        viewReminder.alpha = 0.5;
    }
    if (setReminderSwitch_statement.on) {
        viewReminder_statement.enabled = true;
        viewReminder_statement.alpha = 1.0;
        
    }else{
        viewReminder_statement.enabled = false;
        viewReminder_statement.alpha = 0.5;
    }
}
-(void)visionStatementDateView{
    NSDateFormatter *df = [NSDateFormatter new];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSString *txt=@"";
    if (![Utility isEmptyCheck:_visionBoardDict]) {
        txt = [_visionBoardDict objectForKey:@"VisionDate"];
        txt = [df stringFromDate:[df dateFromString:[Utility getDateOnly:txt]]];
    }
     if (![Utility isEmptyCheck:_visionBoardDict])
     {
         NSDate *date = [df dateFromString:txt];
         [df setDateFormat:@"dd MMM yyyy"];
         txt = [@"" stringByAppendingFormat:@"ON THE %@ :",[df stringFromDate:date]];
         [visionStatementDtBtn setTitle:txt forState:UIControlStateNormal];
     }

}

- (void) shouldPopOnBackButtonWithResponse:(void (^)(BOOL shouldPop))response {
    if (isChanged) {
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"Save Changes"
                                              message:@"Your changes will be lost if you don’t save them."
                                              preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:@"Save"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       [self saveButtonTapped:nil];
                                       response(NO);
                                   }];
        UIAlertAction *cancelAction = [UIAlertAction
                                       actionWithTitle:@"Don't Save"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction *action)
                                       {
                                            if(![Utility isEmptyCheck:self->prvlocalImageName] && ![Utility isEmptyCheck:self->localImageName] && ![self->prvlocalImageName isEqualToString:self->localImageName]){
                                                [Utility removeImage:self->localImageName];
                                                
                                            }
                                           response(YES);
                                       }];
        [alertController addAction:okAction];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    } else {
        response(YES);
    }
}
-(void)uploadImageAlert{
    
    visionDateView.hidden = NO;
    visionReminderView.hidden = NO;
    songView.hidden = NO;
    saveButton.hidden = NO;
    
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




#pragma mark -Notes delegate
- (void) setStatementText:(NSString *) statementText atIndex:(NSInteger) index forKey:(NSString *)key{
//    isChanged=YES;
    isStatementEdited=YES;
    [self setSaveButton];
    
    NSMutableDictionary *dict = [[statementList objectAtIndex:index]mutableCopy];
    [dict setObject:statementText forKey:key];
    [statementList replaceObjectAtIndex:index withObject:dict];
    [statementTable reloadData];
}





//#pragma mark - Load content locally.

/*- (void)loadContent {
 NSString *path = [[NSBundle mainBundle] pathForResource:@"ckeditor/demo.html" ofType:nil];
 [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]]];
 }
 
 
 #pragma mark - WebView Methods
 
 -(void)webViewDidFinishLoad:(UIWebView *)webView{
 dispatch_async(dispatch_get_main_queue(), ^{
 if (![Utility isEmptyCheck:_visionBoardDict]) {
 NSString *detailsString = [_visionBoardDict objectForKey:@"OnThisDateIwillLook"];
 if (![Utility isEmptyCheck:detailsString]) {
 [self.webView stringByEvaluatingJavaScriptFromString:[@"" stringByAppendingFormat:@"document.getElementById('editor').innerHTML='%@';",[detailsString stringByRemovingNewLinesAndWhitespace]]];
 }
 } else {
 
 }
 });
 
 }*/
#pragma mark - QBImagePickerControllerDelegate

- (void)qb_imagePickerController:(QBImagePickerController *)imagePickerController didFinishPickingAssets:(NSArray *)assets
{
    if (![Utility isEmptyCheck:assets]) {
        
//        isChanged = true;
        isVisionEdited=YES;
        [self setSaveButton];
        
//        CGSize screenSize = UIScreen.mainScreen.bounds.size;
//        CGSize targetSize = CGSizeMake(10*screenSize.width, 10*screenSize.height);
        PHImageManager *manager = [PHImageManager defaultManager];
        
        // assets contains PHAsset objects.
        __block UIImage *ima;
        
        for (PHAsset *asset in assets) {
            // Do something with the asset
            
            [manager requestImageForAsset:asset
                               targetSize:PHImageManagerMaximumSize//targetSize
                              contentMode:PHImageContentModeDefault
                                  options:nil
                            resultHandler:^void(UIImage *image, NSDictionary *info) {
                                image = [Utility scaleImage:image width:image.size.width height:image.size.height];
                                image = [UIImage imageWithData:UIImageJPEGRepresentation(image, 0.2)];
                                ima = image;
                                NSMutableDictionary *dict = [NSMutableDictionary new];
                                [dict setObject:[NSNumber numberWithBool:true] forKey:@"isLocal"];
                                [dict setObject:ima forKey:@"image"];
                                [self->imageArray addObject:dict];
                                
                                BOOL addShow = true;
                                if (![Utility isEmptyCheck:self->imageArray]) {
                                    
                                    if (self->imageArray.count < self->_picMaxLimit) {
                                        addShow = false;
                                    } else {
                                        addShow = true;
                                    }
                                } else {
                                   
                                    addShow = false;
                                }
//                                [self->imageCollectionView reloadData];
                            }];
        }
    }
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)qb_imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController
{
    NSLog(@"Canceled.");
    
    [self dismissViewControllerAnimated:YES completion:NULL];
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
    image = [UIImage imageWithData:UIImageJPEGRepresentation(image, 0.2)];  //ah 11.53
    chosenImage = image;
   // visionImageView.hidden = false;
   // uploadImageButton.hidden = true;
    changePicView.hidden = false;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat imageViewHeight = image.size.height/image.size.width * screenWidth;
    visionImageViewHeight.constant = imageViewHeight;
    [self.view setNeedsUpdateConstraints];
//    isChanged = true;
    isVisionEdited=YES;
    isExistingImageChange = true;
    [self setSaveButton];
    [picker dismissViewControllerAnimated:YES completion:^{
        [self openEditor:nil];
    }];
}
#pragma mark - End
#pragma mark - PECropViewControllerDelegate methods

- (void)cropViewController:(PECropViewController *)controller didFinishCroppingImage:(UIImage *)croppedImage transform:(CGAffineTransform)transform cropRect:(CGRect)cropRect
{
    [controller dismissViewControllerAnimated:YES completion:^{
        dispatch_async(dispatch_get_main_queue(),^ {
          
           // [Utility startFlashingbutton:self->saveButton];
          //  [Utility startFlashingbutton:self->doneButton];
            
        });
    }];
    //    userImageView.image = croppedImage;
    //    UIImage *image=[self scaleImage:croppedImage];
    croppedImage = [UIImage imageWithData:UIImageJPEGRepresentation(croppedImage, 0.2)];
    isExistingImageChange = true;
    visionImageView.image = croppedImage;
    chosenImage = croppedImage;
    
    if (croppedImage) {    //ah 17.5 imgview size
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        CGFloat imageViewHeight = croppedImage.size.height/croppedImage.size.width * screenWidth;
        visionImageViewHeight.constant = imageViewHeight;
        [self.view setNeedsUpdateConstraints];
    }
    
    [addEditImageBtn setTitleColor:[UIColor colorWithRed:50.0 / 255.0 green:205.0 / 255.0 blue:184.0 / 255.0 alpha:1.0] forState:UIControlStateNormal];
    addEditImageBtn.backgroundColor = [UIColor whiteColor];
    [addEditImageBtn setTitle:@"CHANGE IMAGE" forState:UIControlStateNormal];
    
    if(visionImageView.isHidden){
        visionImageView.hidden = false;
    }
    
    if(![Utility isEmptyCheck:localImageName]){
           prvlocalImageName = localImageName;
           localImageName = [Utility createImageFileNameFromTimeStamp];
    }else{
           localImageName = [Utility createImageFileNameFromTimeStamp];
    }
       
    [Utility writeImageInDocumentsDirectory:chosenImage imageName:localImageName];
    
    
    //    [self writeImageInDocumentsDirectory:chosenImage];
    //    [self webservicecallForUploadImage];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        //[self updateEditButtonEnabled];
    }
}

- (void)cropViewControllerDidCancel:(PECropViewController *)controller
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        //[self updateEditButtonEnabled];
    }
    
    if(visionImageView.isHidden){
        visionImageView.hidden = false;
    }
    
    if(![Utility isEmptyCheck:localImageName]){
           prvlocalImageName = localImageName;
           localImageName = [Utility createImageFileNameFromTimeStamp];
    }else{
           localImageName = [Utility createImageFileNameFromTimeStamp];
    }
       
    [Utility writeImageInDocumentsDirectory:chosenImage imageName:localImageName];
    
    [controller dismissViewControllerAnimated:YES completion:^{
        dispatch_async(dispatch_get_main_queue(),^ {
           
            //[Utility startFlashingbutton:self->saveButton];
          //  [Utility startFlashingbutton:self->doneButton];
            
        });
    }];
    
}



//chayan 13/10/2017
#pragma mark progressbar delegate

- (void) completedWithResponse:(NSString *)responseString responseDict:(NSDictionary *)responseDict{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"SuccessFlag"] boolValue]) {
            
            
            if(![Utility isEmptyCheck:self->prvlocalImageName]){
                [Utility removeImage:self->prvlocalImageName];
            }
//            [self updateVisionBoardStatement];
             [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateBadgePoint" object:self];//gami_badge_popup
            
            [Utility saveImageDetails:self->localImageName imagetype:VisionBoard Itemid:[[[responseDict objectForKey:@"Details"] objectForKey:@"id"]intValue] existingImageChange:self->isExistingImageChange selectedImage:self->chosenImage];
            self->isExistingImageChange = false;
           [self dismissViewControllerAnimated:YES completion:nil];
            
            self->isVisionEdited=NO;
            [self setSaveButton];
            [self->mainScroll setContentOffset:CGPointZero animated:YES];
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
