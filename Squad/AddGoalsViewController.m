//
//  AddGoalsViewController.m
//  Squad
//
//  Created by AQB SOLUTIONS on 07/03/2017.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import "AddGoalsViewController.h"
#import "Utility.h"
#import "AddGoalQuestion.h"
#import "DropdownViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "SongPlayListViewController.h"
//ah song
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "YLProgressBar.h"
#import "VisionGoalActionTableViewCell.h"
#import "AddActionViewController.h"
#import "SpotifyPlaylistViewController.h"
#import "GratitudeListViewController.h"

@interface AddGoalsViewController ()<SPTAudioStreamingDelegate,SPTAudioStreamingPlaybackDelegate> {
    IBOutlet UIButton *uploadImageButton;
    IBOutlet UIButton *dueDateButton;
    IBOutlet UIButton *categoryButton;
    IBOutlet UIButton *goalValuesButton;
    IBOutlet UISwitch *setReminderSwitch;
    IBOutlet UIButton *deleteButton;
    IBOutlet UIScrollView *mainScroll;
    IBOutlet UIStackView *mainStackView;
    IBOutlet UIView *deleteView;
    IBOutlet UIImageView *goalImageView;
    IBOutlet UIButton *copyButton;
    IBOutlet UIButton *editButton;
    IBOutlet UIView *changePictureView;
    IBOutlet UIButton *uploadPictureSmallButton;
    IBOutlet UIButton *deletePictureButton;
    IBOutlet UIView *setReminderView;
    IBOutlet UIView *goalValueView;
    IBOutlet UIView *categoryView;
    IBOutlet UIButton *doneButton;
    IBOutlet UIButton *saveButton;
    IBOutlet UIButton *viewReminder;
    IBOutlet UITextView *titleTextView;
    IBOutlet NSLayoutConstraint *titleTextViewHeightConstraint;
    IBOutlet UIView *saveCancelView;    //aha
    __weak IBOutlet NSLayoutConstraint *imageViewHeightConstraint;     //ah 22.3
    
    
    NSMutableDictionary *resultDict;
    UITextField *activeTextField;
    UITextView *activeTextView;
    UIToolbar *numberToolbar;
    UIView *contentView;
    NSMutableArray *questionArray;
    NSMutableArray *categoryArray;
    NSDate *selectedDate;
    UIImage *chosenImage;
    BOOL isEdit;
    BOOL isFirstTime;
    //ah song
    IBOutlet UIView *songView;
    IBOutlet UIButton *selectSongButton;
    
    AVAudioPlayer *player;
    
    NSMutableDictionary *savedReminderDict;     //ah ln
    
    BOOL isChanged;
    BOOL isFirstTimeReminderSet;//gami_badge_popup

    //new update
    __weak IBOutlet UITextField *actionNameTextField;
    __weak IBOutlet UITableView *actionTable;
    __weak IBOutlet NSLayoutConstraint *actionTableHeight;
    __weak IBOutlet YLProgressBar *progressBar;
    __weak IBOutlet UILabel *progressLabel;
    __weak IBOutlet UIButton *showButton;
    __weak IBOutlet UIView *showHideView;
    __weak IBOutlet UIStackView *categoryStackView;
    __weak IBOutlet UIStackView *goalValuesStackView;
    __weak IBOutlet UIView *tableSuperView;
    __weak IBOutlet UIView *pictureView;
    __weak IBOutlet UIImageView *otherImageView;
    __weak IBOutlet UIView *editView;
    __weak IBOutlet UILabel *newActionLabel;
    __weak IBOutlet UIButton *publicButton;
    __weak IBOutlet UIButton *privateButton;
    __weak IBOutlet UIView *privacyView;
    __weak IBOutlet UIView *footerView;
    __weak IBOutlet UIButton *saveButtonTop;
    __weak IBOutlet UIButton *actionArrowbutton;
    __weak IBOutlet UIButton *mainfestGoalArrButton;
    __weak IBOutlet UIView *blankView;
    __weak IBOutlet UIView *questiontextDetailsView;
    __weak IBOutlet UIButton *quesSaveButton;
    __weak IBOutlet UITextView *quesTextView;
    __weak IBOutlet UIButton *backButton;
    __weak IBOutlet UIView *quesSaveView;
    __weak IBOutlet UIButton *reminderButton;
    BOOL isActionExapnd;
    BOOL ismaniFestExpand;
    int quesTag;
    NSArray *detailsPlaceholderArr;
    
}

@end

@implementation AddGoalsViewController
@synthesize editMode,goalName,sPlayer;
//ah newt
- (void)viewDidLoad {
    [super viewDidLoad];
    
    resultDict = [[NSMutableDictionary alloc]init];
    questionArray = [[NSMutableArray alloc]init];
    categoryArray = [[NSMutableArray alloc]init];
//    isEdit = NO;
    isFirstTime = YES;
    isChanged = NO;
    isFirstTimeReminderSet = true; //gami_badge_popup
    isActionExapnd = true;
    
    questiontextDetailsView.hidden =true;
    quesSaveView.hidden = true;
    actionArrowbutton.selected = true;
    [Utility stopFlashingbutton:saveButton];
    [Utility stopFlashingbutton:doneButton];
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDate *newDate = [cal dateByAddingUnit:NSCalendarUnitMonth value:1 toDate:[NSDate date] options:0];
    selectedDate = newDate;
    detailsPlaceholderArr =@[@"Example:By being consistent in ticking off my ACTIONS",@"Example:I will have a better lifestyle",@"Example:Happy"];
//                             @"Example:Disappointment,but the chance to learn",@"Example:Old habits,beliefs,enviroments,people",@"Example:Disappointment,but the chance to learn",@"Example:Old habits,beliefs,enviroments,people
    numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone  target:self action:@selector(doneWithFirstResponder)],nil];
    [numberToolbar sizeToFit];
    titleTextView.inputAccessoryView = numberToolbar;
    quesTextView.inputAccessoryView = numberToolbar;
    [self registerForKeyboardNotifications];
    
    if (![Utility isEmptyCheck:_selectedGoalDict] && _selectedGoalDict.count > 0) {
        deleteButton.hidden = NO;
        copyButton.hidden = YES;
        editButton.hidden = NO;
        editView.hidden = YES;
        if (![Utility isEmptyCheck:[_selectedGoalDict objectForKey:@"Picture"]]) {
            changePictureView.hidden = NO;
        } else {
            changePictureView.hidden = YES;
        }
        actionTable.hidden = false;
        tableSuperView.hidden = false;
//        [actionTable reloadData];
//        [self updateProgressView];
    } else {
        deleteButton.hidden = YES;
        copyButton.hidden = YES;
        editButton.hidden = YES;
        editView.hidden = YES;
        changePictureView.hidden = YES;
        actionTable.hidden = true;
        tableSuperView.hidden = true;
    }
//    mainStackView.subviews arr and loop through to get textview referance
    actionTable.estimatedRowHeight = 70;
    actionTable.rowHeight = UITableViewAutomaticDimension;
//    [self makeBorder:dueDateButton mainColor:false];
//    [self makeBorder:selectSongButton mainColor:false];
    [self makeBorder:viewReminder mainColor:false];
    [self makeBorder:showButton mainColor:false];
    [self makeBorder:editButton mainColor:true];
    [self makeBorder:publicButton mainColor:true];
    [self makeBorder:privateButton mainColor:true];
    saveButtonTop.layer.cornerRadius = 15;
    saveButtonTop.layer.masksToBounds = YES;
    uploadImageButton.layer.cornerRadius = 15;
    uploadImageButton.layer.masksToBounds = YES;
    quesSaveButton.layer.cornerRadius = 15;
    quesSaveButton.layer.masksToBounds = YES;
    saveCancelView.layer.cornerRadius = 15;
    saveCancelView.layer.masksToBounds = true;
    publicButton.selected = true;
    privateButton.selected = false;
    showButton.selected = true;
    showButton.tag = 1;
    if (![Utility isEmptyCheck:_buddyDict]) {
        saveCancelView.hidden = true;
        deleteButton.hidden = true;
        editView.hidden = true;
    }
    mainScroll.hidden = true;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    ismaniFestExpand = false;
    editMode = true;
    [actionTable addObserver:self forKeyPath:@"contentSize" options:0 context:NULL];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(quitList:) name:@"backButtonPressed" object:nil];
    if (isFirstTime) {
        isFirstTime = NO;
        [self getQuestions];
        //        if ([Utility isEmptyCheck:_valuesArray]) {  //ahln
        //            [self getGoalValue];
        //        }
    }
}
-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [self.view endEditing:YES];
    [actionTable removeObserver:self forKeyPath:@"contentSize"];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"backButtonPressed" object:nil];
    [player pause];
    if (self.sPlayer) {
        [self.sPlayer setIsPlaying:NO callback:nil];
    }
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
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if (object == actionTable) {
        actionTableHeight.constant = actionTable.contentSize.height;
    }
}
-(void)updateProgressView{
    float currProgress = 0.0;
    @try{
        NSDateFormatter *dailyDateformatter = [[NSDateFormatter alloc]init];
        NSString *startDateStr = [_selectedGoalDict objectForKey:@"CreatedAt"];
        NSArray *dateArr = [startDateStr componentsSeparatedByString:@"T"];
        startDateStr = [dateArr objectAtIndex:0];
        [dailyDateformatter setDateFormat:@"yyyy-MM-dd"];
        
        NSString *dateStr = [_selectedGoalDict objectForKey:@"DueDate"];
        dateArr = [dateStr componentsSeparatedByString:@"T"];
        dateStr = [dateArr objectAtIndex:0];
        
        NSDateComponents *components;
        NSInteger days;
        NSInteger totalDays;
        if ([[dailyDateformatter dateFromString:startDateStr] isEarlierThanOrEqualTo:[NSDate date]] && [[NSDate date] isEarlierThanOrEqualTo:[dailyDateformatter dateFromString:dateStr]]) {
            components = [[NSCalendar currentCalendar] components: NSCalendarUnitDay fromDate: [dailyDateformatter dateFromString:startDateStr] toDate: [NSDate date] options: 0];
        } else {
            components = [[NSCalendar currentCalendar] components: NSCalendarUnitDay fromDate: [dailyDateformatter dateFromString:startDateStr] toDate: [dailyDateformatter dateFromString:dateStr] options: 0];
        }
        days = [components day];
        
        components = [[NSCalendar currentCalendar] components: NSCalendarUnitDay fromDate: [dailyDateformatter dateFromString:startDateStr] toDate: [dailyDateformatter dateFromString:dateStr] options: 0];
        totalDays = [components day];
        
        if ([[dailyDateformatter dateFromString:startDateStr] isSameDay:[dailyDateformatter dateFromString:dateStr]]) {
            if ([[dailyDateformatter dateFromString:startDateStr] isSameDay:[NSDate date]]) {
                days = 0;
            }else{
                days = 1;
            }
            totalDays = 1;
        }
        if (totalDays != 0) {
            currProgress = (float)days / totalDays;
        }
        if (currProgress > 1.0) {
            currProgress = 1.0;
        }
    }@catch(NSException *exception){
        NSLog(@"updateProgressView exception occur");
    }
    progressBar.type = YLProgressBarTypeFlat;
    progressBar.progress = currProgress;
    int progressInt = currProgress*100.0;
    progressLabel.text = [NSString stringWithFormat:@"%@%%",[Utility customRoundNumber:(float)progressInt]];
}
-(void)makeBorder:(UIButton *)sender mainColor:(BOOL)mainColor{
    if (mainColor) {
        sender.layer.borderColor = squadMainColor.CGColor;
    } else {
        sender.layer.borderColor = squadSubColor.CGColor;
    }
    sender.layer.borderWidth = 1;
}
#pragma mark - IBAction
- (IBAction)back:(id)sender {
    [self shouldPopOnBackButtonWithResponse:^(BOOL shouldPop) {
        if (shouldPop) {
            if (self->isEdit) {
                self->isChanged = NO;
                [Utility stopFlashingbutton:self->saveButton];
                [Utility stopFlashingbutton:self->doneButton];
                self->isEdit = NO;
                [self prepareView];
            }else{
                [self.navigationController popViewControllerAnimated:YES];
                //                                                                           [self dismissViewControllerAnimated:YES completion:nil];
            }
        }
    }];
    [player pause];
    if (self.sPlayer && self.sPlayer.playbackState.isPlaying) {
        [self.sPlayer setIsPlaying:NO callback:nil];
    }
}
- (IBAction)logoTapped:(id)sender {
    [self shouldPopOnBackButtonWithResponse:^(BOOL shouldPop) {
        if (shouldPop) {
//            [self.navigationController popToRootViewControllerAnimated:YES];
            if(([Utility isSubscribedUser] && [Utility isOfflineMode]) || [Utility isSquadLiteUser] || [Utility isSquadFreeUser]) {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }else{
//                TodayHomeViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"TodayHome"];
//                GratitudeListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"GratitudeListView"];
                AchievementsViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"Achievements"];
                [self.navigationController pushViewController:controller animated:YES];
            }
//            [self dismissViewControllerAnimated:YES completion:nil];
//            [self dismissViewControllerAnimated:YES completion:^{
//                [self.presentingViewController.navigationController  popToRootViewControllerAnimated:YES];
//            }];
        }

        
    }];
}
- (IBAction)doneTapped:(id)sender {
//    NSLog(@"res %@",resultDict);
//    if (actionNameTextField.text.length>0) {
//        [actionNameTextField becomeFirstResponder];
//        [Utility msg:@"Please add the action first to save goal" title:@"" controller:self haveToPop:NO];
//    } else {
//        if ([self validationCheck]) {
//            //[self saveData];
//            [self saveDataMultiPart];
//        }
//    }
    if ([self validationCheck]) {
        //[self saveData];
        [self saveDataMultiPart];
    }
    
}
- (IBAction)uploadImageTapped:(id)sender {
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
- (IBAction)dueDateButtonTapped:(id)sender {
    DatePickerViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DatePicker"];
    controller.modalPresentationStyle = UIModalPresentationCustom;
    controller.selectedDate = selectedDate;
    controller.datePickerMode = UIDatePickerModeDate;
    controller.delegate = self;
    [self presentViewController:controller animated:YES completion:nil];
}
- (IBAction)categoryButtonTapped:(UIButton *)sender {
    if (sender.isSelected) {
        return;
    }
    isChanged = YES;
    for (UIButton *button in categoryStackView.subviews) {
        if (sender == button) {
            [button setBackgroundColor:squadMainColor];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button setSelected:true];
        } else {
            [button setBackgroundColor:[UIColor whiteColor]];
            [button setTitleColor:squadMainColor forState:UIControlStateNormal];
            [button setSelected:false];
        }
    }
    
    [resultDict setObject:[NSNumber numberWithInteger:sender.tag] forKey:@"CategoryId"];
//    int catID = [[resultDict objectForKey:@"CategoryId"] intValue];
//    int selectedIndex = -1;
//    for (int i = 0; i < categoryArray.count; i++) {
//        int cid = [[[categoryArray objectAtIndex:i] objectForKey:@"id"] intValue];
//        if (cid == catID) {
//            selectedIndex = i;
//        }
//    }
//    DropdownViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Dropdown"];
//    controller.modalPresentationStyle = UIModalPresentationCustom;
//    controller.dropdownDataArray = categoryArray;
//    controller.mainKey = @"CategoryName";
//    controller.apiType = @"Category";
//    controller.selectedIndex = selectedIndex;
//    controller.delegate = self;
//    [self presentViewController:controller animated:YES completion:nil];
}
- (IBAction)goalValuesTapped:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    isChanged = YES;
    
    if (sender.isSelected) {
        [sender setBackgroundColor:squadMainColor];
        [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    } else {
        [sender setBackgroundColor:[UIColor whiteColor]];
        [sender setTitleColor:squadMainColor forState:UIControlStateNormal];
    }
    NSString *ids = [resultDict objectForKey:@"GoalValueData"];
//    NSArray *idArr;
    NSMutableArray *idMutableArr = [NSMutableArray new];
    if (![Utility isEmptyCheck:ids]) {
        idMutableArr = [[ids componentsSeparatedByString:@","] mutableCopy];
    }
    
    if ([idMutableArr containsObject:[@"" stringByAppendingFormat:@"%@",[NSNumber numberWithInteger:sender.tag]]]) {
        [idMutableArr removeObject:[@"" stringByAppendingFormat:@"%@",[NSNumber numberWithInteger:sender.tag]]];
    }else{
        [idMutableArr addObject:[@"" stringByAppendingFormat:@"%@",[NSNumber numberWithInteger:sender.tag]]];
    }
    if (idMutableArr.count > 0){
        [resultDict setObject:[idMutableArr componentsJoinedByString:@","] forKey:@"GoalValueData"];
    }else {
        [resultDict setObject:@"" forKey:@"GoalValueData"];
        [resultDict setObject:[NSArray new] forKey:@"GoalValuesMapDetails"];
    }
    
//    DropdownViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Dropdown"];
//    controller.modalPresentationStyle = UIModalPresentationCustom;
//    controller.dropdownDataArray = _valuesArray;
//    controller.mainKey = @"value";
//    controller.apiType = @"goalValue";
//    controller.selectedIndex = -1;
//    controller.delegate = self;
//    controller.sender = sender;
//    NSMutableArray *array = [[NSMutableArray alloc]init];
//    if ([sender.titleLabel.text caseInsensitiveCompare:@"Select Values"] != NSOrderedSame) {
//        NSArray *titleArray = [sender.titleLabel.text componentsSeparatedByString:@", "];
//        for (int i =0;i<titleArray.count;i++) {
//            NSString *title = [titleArray objectAtIndex:i];
//            for (int j = 0; j < _valuesArray.count; j++) {
//                NSDictionary *dict = [_valuesArray objectAtIndex:j];
//                if ([[dict objectForKey:@"value"] caseInsensitiveCompare:title] == NSOrderedSame) {
//                    [array addObject:[NSNumber numberWithInteger:j]];
//                }
//            }
//
//        }
//        controller.selectedIndexes=array;
//    }
//    controller.multiSelect = true;
//    [self presentViewController:controller animated:YES completion:nil];
}
- (IBAction)setReminderPressed:(id)sender {
    if (!reminderButton.selected) {
        SetReminderViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SetReminder"];
        if ([resultDict objectForKey:@"FrequencyId"] != nil)
            controller.defaultSettingsDict = resultDict;
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
//        [resultDict setObject:[NSNumber numberWithBool:false] forKey:@"PushNotification"];
//        [resultDict setObject:[NSNumber numberWithBool:false] forKey:@"Email"];
        
//        UISwitch *remSwitch = (UISwitch *)sender;
//        [remSwitch setOn:YES];
        reminderButton.selected = true;
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:nil
                                              message:nil
                                              preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:@"Edit Reminder"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       [self viewReminder:0];
                                   }];
        UIAlertAction *turnOff = [UIAlertAction
                                  actionWithTitle:@"Turn Off Reminder"
                                  style:UIAlertActionStyleDefault
                                  handler:^(UIAlertAction *action)
                                  {
//                                      UISwitch *remSwitch = (UISwitch *)sender;
//                                      [remSwitch setOn:NO];
                                      self->reminderButton.selected = false;
                                      [self->resultDict removeObjectForKey:@"FrequencyId"];
                                      [self prepareReminderView];
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

- (IBAction)deleteButtonTapped:(id)sender {
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Comfirm Delete"
                                          message:@"Do you want to delete this goal?"
                                          preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:@"Delete"
                               style:UIAlertActionStyleDestructive
                               handler:^(UIAlertAction *action)
                               {
                                   [self deleteGoal];
                                   
                                   //                                   if (SYSTEM_VERSION_LESS_THAN(@"10")) {   //ah ln1
                                   NSArray *requests = [[UIApplication sharedApplication] scheduledLocalNotifications];
                                   for (UILocalNotification *req in requests) {
                                       NSString *pushTo = [req.userInfo objectForKey:@"pushTo"];
                                       if ([pushTo caseInsensitiveCompare:@"Goal"] == NSOrderedSame) {
                                           int bucketRemID = [[req.userInfo objectForKey:@"ID"] intValue];
                                           if (bucketRemID == [[self->_selectedGoalDict objectForKey:@"id"] intValue]) {
                                               [[UIApplication sharedApplication] cancelLocalNotification:req];
                                           }
                                       }
                                   }
                                   //                                   } else {
                                   //                                       NSMutableArray *removeIDs = [[NSMutableArray alloc] init];
                                   //
                                   //                                       UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
                                   //                                       [center getPendingNotificationRequestsWithCompletionHandler:^(NSArray<UNNotificationRequest *> * _Nonnull requests) {
                                   //                                           for (UNNotificationRequest *req in requests) {
                                   //                                               NSString *remId = req.identifier;
                                   //                                               NSArray *arr = [remId componentsSeparatedByString:@"_"];
                                   //                                               if ([[arr objectAtIndex:1] caseInsensitiveCompare:@"Goal"] == NSOrderedSame) {
                                   //                                                   int bucketRemID = [[arr objectAtIndex:2] intValue];
                                   //                                                   if (bucketRemID == [[_selectedGoalDict objectForKey:@"id"] intValue]) {
                                   //                                                       [removeIDs addObject:remId];
                                   //                                                       [center removePendingNotificationRequestsWithIdentifiers:removeIDs];
                                   //                                                   }
                                   //                                               }
                                   //                                           }
                                   //                                       }];
                                   //                                   }
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
- (IBAction)openEditor:(id)sender
{
    PECropViewController *controller = [[PECropViewController alloc] init];
    controller.delegate = self;
    controller.image = goalImageView.image;
    controller.keepingCropAspectRatio = YES;
    
    //    UIImage *image = profileImageView.image;
    //    CGFloat width = image.size.width;
    //    CGFloat height = image.size.height;
    //    CGFloat length = MIN(width, height);
    //    controller.imageCropRect = CGRectMake((width - length) / 2,
    //                                          (height - length) / 2,
    //                                          length,
    //                                          length);
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
    }
    
    [self presentViewController:navigationController animated:YES completion:NULL];
}

-(IBAction)editTapped:(id)sender {
    isEdit = YES;
    [self prepareView];
}
-(IBAction)copyTapped:(id)sender {
    titleTextView.text = [NSString stringWithFormat:@"COPY OF : %@",titleTextView.text];
    titleTextViewHeightConstraint.constant = titleTextView.contentSize.height;
    [resultDict setObject:titleTextView.text forKey:@"Name"];
    [resultDict setObject:[NSNumber numberWithInt:0] forKey:@"id"];
    copyButton.hidden = true;
}
-(IBAction)deletePictureTapped:(id)sender {
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Comfirm Delete"
                                          message:@"Do you want to delete the picture?"
                                          preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:@"Delete"
                               style:UIAlertActionStyleDestructive
                               handler:^(UIAlertAction *action)
                               {
                                   self->chosenImage = nil;
                                   [self->resultDict setObject:@"" forKey:@"UploadPictureImgBase64"];
                                   [self->resultDict setObject:@"" forKey:@"Picture"];
                                   self->changePictureView.hidden = YES;
                                   self->uploadImageButton.hidden = false;
                                   self->goalImageView.image = [UIImage imageNamed:@"upload_image.png"];
                                   self->goalImageView.hidden = true;
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
- (IBAction)viewReminder:(UIButton *)sender {
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
    //**
//    SpotifyPlaylistViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SpotifyPlaylist"];
//    controller.delegate = self;
//    [self presentViewController:controller animated:YES completion:nil];
    //**
    SongPlayListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PlayListView"];
    controller.isSelectMusic = YES;
    controller.delegate = self;
    [self presentViewController:controller animated:YES completion:nil];    //ah song
}
- (IBAction)addActionPessed:(UIButton *)sender {
    //    if (actionNameTextField.text.length>0) {
    isFirstTime = true;
    AddActionViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AddAction"];
    controller.selectedGoal = _selectedGoalDict;
    controller.isNewAction = true; //gami_badge_popup
    controller.actionName = @"ADD ACTION";//actionNameTextField.text;
    [self.navigationController pushViewController:controller animated:YES];
    //        [self presentViewController:controller animated:YES completion:nil];
//    actionNameTextField.text = @"";
    //    }
}
- (IBAction)showButtonPressed:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    BOOL show = sender.selected;
    if(sender.isSelected){
        [otherImageView setImage:[UIImage imageNamed:@"down_arr.png"]];
    }else{
        [otherImageView setImage:[UIImage imageNamed:@"fp_up_arr.png"]];
    }
    if (![Utility isEmptyCheck:_selectedGoalDict] && _selectedGoalDict.count > 0 && !isEdit) {
        [self prepareView];
    } else if (![Utility isEmptyCheck:_selectedGoalDict] && _selectedGoalDict.count > 0 && isEdit) {
        [self prepareView];
    } else {
        for (UIView *subview in [mainStackView subviews]) {
            if ([subview isKindOfClass:[AddGoalQuestion class]]) {
                subview.hidden = show;
            }
        }
        songView.hidden = show;
        pictureView.hidden = show;
        privacyView.hidden = show;
    }
}
- (IBAction)privacyButtonPessed:(UIButton *)sender {
    if (sender.isSelected) {
        return;
    }
    isChanged = true;
    if (sender == privateButton) {
        privateButton.selected = true;
        publicButton.selected = false;
        [privateButton setBackgroundColor: squadMainColor];
        [publicButton setBackgroundColor: [UIColor whiteColor]];
    } else {
        privateButton.selected = false;
        publicButton.selected = true;
        [privateButton setBackgroundColor: [UIColor whiteColor]];
        [publicButton setBackgroundColor: squadMainColor];
    }
    if (publicButton.isSelected) {
        [resultDict setObject:[NSNumber numberWithBool:NO] forKey:@"Buddy_Privacy"];
        [_selectedGoalDict setObject:[NSNumber numberWithBool:NO] forKey:@"Buddy_Privacy"];
        
    } else {
        [resultDict setObject:[NSNumber numberWithBool:YES] forKey:@"Buddy_Privacy"];
        [_selectedGoalDict setObject:[NSNumber numberWithBool:YES] forKey:@"Buddy_Privacy"];
    }
}
-(IBAction)manifestExpandCollapse:(id)sender{
    if (ismaniFestExpand) {
        mainfestGoalArrButton.selected = false;
        ismaniFestExpand = false;
        for (UIView *subview in [mainStackView subviews]) {
            if ([subview isKindOfClass:[AddGoalQuestion class]]) {
                subview.hidden = YES;
            }
        }
        songView.hidden = YES;
        pictureView.hidden = YES;
        privacyView.hidden = YES;
    }else{
        ismaniFestExpand = true;
        mainfestGoalArrButton.selected = true;
      
        for (UIView *subview in [mainStackView subviews]) {
            if ([subview isKindOfClass:[AddGoalQuestion class]]) {
                subview.hidden = NO;
            }
        }
        songView.hidden = false;
        pictureView.hidden = false;
        privacyView.hidden = false;
    }
}
-(IBAction)actionExpandCollapse:(id)sender{
    if (isActionExapnd) {
        isActionExapnd = false;
        actionArrowbutton.selected = false;
    }else{
        isActionExapnd = true;
        actionArrowbutton.selected = true;
    }
    [actionTable reloadData];
}
-(IBAction)quesSaveButtonPressed:(id)sender{
    [self.view endEditing:true];
    if ([detailsPlaceholderArr containsObject:quesTextView.text]) {
        return;
    }
    questiontextDetailsView.hidden = true;
    quesSaveView.hidden = true;
    saveCancelView.hidden = false;
    NSLog(@"%@",quesTextView.text);
  
    for (int i = 0; i < questionArray.count; i++) {
        UITextView *textView = (UITextView*)[self.view viewWithTag:i+1001];
        if ([textView isKindOfClass:[UITextView class]] && (textView.tag == quesTag)) {
            textView.text = quesTextView.text;
            textView.textColor = [[Utility colorWithHexString:@"333333"]colorWithAlphaComponent:1];
        }
    }
}

-(IBAction)backButtonPressed:(UIButton*)sender{
    if (!questiontextDetailsView.hidden) {
        [self.view endEditing:true];
        questiontextDetailsView.hidden = true;
        quesSaveView.hidden = true;
        saveCancelView.hidden = false;
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark - API call
-(void) getQuestions {
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!self->contentView || ![self->contentView isDescendantOfView:self.view]) {
//                [contentView removeFromSuperview];
                self->contentView = [Utility activityIndicatorView:self];
            }
//            contentView = [Utility activityIndicatorView:self];
        });
        NSURLSession *achieveSession = [NSURLSession sharedSession];
        
        NSError *error;
        
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
//        [mainDict setObject:[defaults objectForKey:@"UserID"] forKey:@"UserID"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetMotivationQuestionAPI" append:@"" forAction:@"POST"];
        
        NSURLSessionDataTask * dataTask =[achieveSession dataTaskWithRequest:request
                                                           completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                               dispatch_async(dispatch_get_main_queue(),^ {
//                                                                   if (contentView) {
//                                                                       [contentView removeFromSuperview];
//                                                                   }
                                                                   if(error == nil)
                                                                   {
                                                                       NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                       NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                       if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDictionary] && [[responseDictionary objectForKey:@"SuccessFlag"] boolValue]) {
                                                                           for (UIView *subview in [self->mainStackView subviews]) {
                                                                               if ([subview isKindOfClass:[AddGoalQuestion class]]) {
                                                                                   [self->mainStackView removeArrangedSubview:subview];
                                                                                   [subview removeFromSuperview];
                                                                               }
                                                                           }
                                                                           int index = 1000;
                                                                           NSArray *detailsArr = [responseDictionary objectForKey:@"Details"];
                                                                         
                                                                           for (int i = 0; i < detailsArr.count; i++) {
                                                                               if ([[[detailsArr objectAtIndex:i] objectForKey:@"IsGoal"] boolValue]) {
                                                                                   NSArray *enrolledCoursesViewObjects = [[NSBundle mainBundle] loadNibNamed:@"AddGoalQuestion" owner:self options:nil];
                                                                                   AddGoalQuestion *addGoalQuestion= [enrolledCoursesViewObjects objectAtIndex:0];
                                                                                   addGoalQuestion.titleLabel.text = [[detailsArr objectAtIndex:i] objectForKey:@"Question"];
                                                                                   addGoalQuestion.answerTextView.delegate = self;
                                                                                   addGoalQuestion.answerTextView.text = self->detailsPlaceholderArr[i];
                                                                                   addGoalQuestion.answerTextView.textColor = [[Utility colorWithHexString:@"333333"]colorWithAlphaComponent:0.5];
//                                                                                   addGoalQuestion.answerTextView.layer.borderWidth = 1;
//                                                                                   addGoalQuestion.answerTextView.layer.borderColor = squadSubColor.CGColor;
                                                                                   [addGoalQuestion.answerTextView setTag:index+1];
                                                                                   addGoalQuestion.answerTextView.inputAccessoryView = self->numberToolbar;
                                                                                   [addGoalQuestion setTag:[[[detailsArr objectAtIndex:i] objectForKey:@"id"] integerValue]+101];
//                                                                                   [mainStackView addArrangedSubview:addGoalQuestion];
                                                                                   [self->mainStackView insertArrangedSubview:addGoalQuestion atIndex:5];    //aha
                                                                                   index++;
                                                                                   [self->questionArray addObject:[detailsArr objectAtIndex:i]];
                                                                               }
                                                                           }
                                                                       }else{
                                                                           [Utility msg:[responseDictionary objectForKey:@"ErrorMessage"] title:@"Error !" controller:self haveToPop:NO];
                                                                           return;
                                                                       }
                                                                       
                                                                   }else{
                                                                       [Utility msg:error.localizedDescription title:@"Error !" controller:self haveToPop:NO];
                                                                   }
                                                                   [self getCategory];
                                                               });
                                                           }];
        [dataTask resume];
        
    }else{
        [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
    }
    
}

-(void) getCategory {
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!self->contentView || ![self->contentView isDescendantOfView:self.view]) {
//                [contentView removeFromSuperview];
                self->contentView = [Utility activityIndicatorView:self];
            }
//            contentView = [Utility activityIndicatorView:self];
        });
        NSURLSession *achieveSession = [NSURLSession sharedSession];
        
        NSError *error;
        
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        //        [mainDict setObject:[defaults objectForKey:@"UserID"] forKey:@"UserID"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetCategoryAPI" append:@"" forAction:@"POST"];
        
        NSURLSessionDataTask * dataTask =[achieveSession dataTaskWithRequest:request
                                                           completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                               dispatch_async(dispatch_get_main_queue(),^ {
//                                                                   if (contentView) {
//                                                                       [contentView removeFromSuperview];
//                                                                   }
                                                                   if(error == nil)
                                                                   {
                                                                       NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                       NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                       if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDictionary] && [[responseDictionary objectForKey:@"SuccessFlag"] boolValue]) {
                                                                           
                                                                           self->categoryArray = [responseDictionary objectForKey:@"Details"];
                                                                           
                                                                           for (UIButton *button in self->categoryStackView.subviews) {
                                                                               [self->categoryStackView removeArrangedSubview:button];
                                                                               [button removeFromSuperview];
                                                                           }
                                                                           for (NSDictionary *temp in self->categoryArray) {
                                                                               UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                                                                               
                                                                               [button addTarget:self action:@selector(categoryButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
                                                                               [button setTitle:[temp objectForKey:@"CategoryName"] forState:UIControlStateNormal];
                                                                               button.tag =[[temp objectForKey:@"id"] integerValue];
                                                                               button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                                                                               button.titleLabel.font =[UIFont fontWithName:@"Raleway-Medium" size:17];
                                                                               if ([[temp objectForKey:@"id"] integerValue] == 10) {
                                                                                   [button setBackgroundColor:squadMainColor];
                                                                                   [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                                                                                   [button setSelected:true];
                                                                               } else {
                                                                                   [button setBackgroundColor:[UIColor whiteColor]];
                                                                                   [button setTitleColor:squadMainColor forState:UIControlStateNormal];
                                                                                   [button setSelected:false];
                                                                               }
                                                                               [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
                                                                               [self makeBorder:button mainColor:YES];
                                                                               
                                                                               [self->categoryStackView addArrangedSubview:button];
                                                                           }
                                                                           [self.view layoutIfNeeded];
                                                                           
                                                                           if (![Utility isEmptyCheck:self->_selectedGoalDict] && self->_selectedGoalDict.count > 0) {
                                                                               [self getSelectDetails];
                                                                           } else {
                                                                               if (self->contentView) {
                                                                                   [self->contentView removeFromSuperview];
                                                                               }
                                                                               [self prepareView];
                                                                           }
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

-(void) getSelectDetails {
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!self->contentView || ![self->contentView isDescendantOfView:self.view]) {
//                [contentView removeFromSuperview];
                self->contentView = [Utility activityIndicatorView:self];
            }
//            contentView = [Utility activityIndicatorView:self];
        });
        NSURLSession *achieveSession = [NSURLSession sharedSession];
        
        NSError *error;
        
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:[_selectedGoalDict objectForKey:@"id"] forKey:@"GoalId"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetGoalSelectAPI" append:@"" forAction:@"POST"];
        
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
                                                                           
                                                                           self->_selectedGoalDict = [[responseDictionary objectForKey:@"Details"]mutableCopy];
                                                                           NSArray *actionArray = [self->_selectedGoalDict objectForKey:@"GoalActionDetails"];
                                                                           if(![Utility isEmptyCheck:actionArray]){
                                                                               self->newActionLabel.text = @"Add new action here";
                                                                           }else{
                                                                               NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@"Click the + to add an action you will complete regularly to achieve your goal"];
                                                                               NSRange foundRange = [text.mutableString rangeOfString:@"+"];

                                                                               NSDictionary *attrDict = @{
                                                                                                          NSFontAttributeName : [UIFont fontWithName:@"Raleway-Medium" size:15.0],
                                                                                                          NSForegroundColorAttributeName : squadSubColor
                                                                                                          };
                                                                               [text addAttributes:attrDict range:NSMakeRange(0, text.length)];
                                                                               [text addAttributes:@{ NSFontAttributeName : [UIFont fontWithName:@"Symbol" size:15.0] } range:foundRange];
                                                                               self->newActionLabel.attributedText = text;
//                                                                               self->newActionLabel.text = @"Click the plus to add an action you will complete regularly to achieve your goal";
                                                                           }
                                                                           [self prepareView];
                                                                           
                                                                       } else {
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
        
        //change to save goalVal ids
        if (![Utility isEmptyCheck:[resultDict objectForKey:@"GoalValueData"]]) {
            NSRange hashRange = [[resultDict objectForKey:@"GoalValueData"] rangeOfString:@"###"];
            if (hashRange.location == NSNotFound) {
                NSArray *goalValArr = [[resultDict objectForKey:@"GoalValueData"] componentsSeparatedByString:@","];
                [resultDict setObject:[goalValArr componentsJoinedByString:@"###,"] forKey:@"GoalValueData"];
            }
        }
        //end
        
        
        [resultDict setObject:titleTextView.text forKey:@"Name"];

//        NSArray *subViewArray = [mainStackView subviews];
        NSMutableArray *ansArr = [[NSMutableArray alloc]init];
        NSArray *ansArray = [_selectedGoalDict objectForKey:@"AnswerDetails"];

        for (int i = 0; i < questionArray.count; i++) {
            UITextView *textView = (UITextView*)[self.view viewWithTag:i+1];
            
            if ([textView isKindOfClass:[UITextView class]]) {
                NSMutableDictionary *ansDict = [[NSMutableDictionary alloc]init];
                if (![Utility isEmptyCheck:ansArray] && ansArray.count > 0 && ![Utility isEmptyCheck:[[ansArray objectAtIndex:i] objectForKey:@"id"]])
                    [ansDict setObject:[[ansArray objectAtIndex:i] objectForKey:@"id"] forKey:@"id"];
                else
                    [ansDict setObject:[NSNumber numberWithInt:0] forKey:@"id"];
                
                if (![Utility isEmptyCheck:[_selectedGoalDict objectForKey:@"id"]])
                    [ansDict setObject:[_selectedGoalDict objectForKey:@"id"] forKey:@"GoalId"];
                else
                    [ansDict setObject:[NSNumber numberWithInt:0] forKey:@"GoalId"];
                
                [ansDict setObject:[[questionArray objectAtIndex:i] objectForKey:@"id"] forKey:@"MotivationQuestionId"];
                [ansDict setObject:textView.text forKey:@"Answer"];
                [ansDict setObject:[[questionArray objectAtIndex:i] objectForKey:@"Question"] forKey:@"Question"];
                [ansArr addObject:ansDict];
            }
        }
        if (ansArr.count > 0) {
            [resultDict setObject:ansArr forKey:@"AnswerDetails"];
        }
        
        if (![Utility isEmptyCheck:chosenImage]) {
            NSString *imgBase64Str = [UIImagePNGRepresentation(chosenImage) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
            NSLog(@"img %@",imgBase64Str);
            [resultDict setObject:imgBase64Str forKey:@"UploadPictureImgBase64"];
        }
        
        if ([Utility isEmptyCheck:[resultDict objectForKey:@"IsCreatedUpdated"]]) {    //ah ac2
            [resultDict setObject:[NSNumber numberWithBool:NO] forKey:@"IsCreatedUpdated"];
        }
        if ([Utility isEmptyCheck:[resultDict objectForKey:@"AnswerDetails"]]) {    //ah ac2
            [resultDict setObject:[NSArray new] forKey:@"AnswerDetails"];
        }
        if ([Utility isEmptyCheck:[resultDict objectForKey:@"GoalActionDetails"]]) {    //ah ac2
            [resultDict setObject:[NSArray new] forKey:@"GoalActionDetails"];
        }
        if ([Utility isEmptyCheck:[resultDict objectForKey:@"QuestionDetails"]]) {    //ah ac2
            [resultDict setObject:[NSArray new] forKey:@"QuestionDetails"];
        }
        
//        [resultDict setObject:@"" forKey:@"Song"];
        
        
        NSError *error;
        
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults objectForKey:@"UserID"] forKey:@"UserID"];
        [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"AbbbcSessionId"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"AbbbcUserId"];
        [mainDict setObject:resultDict forKey:@"model"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"AddUpdateGoalAPI" append:@"" forAction:@"POST"];
        
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
                                                                           
                                                                           //ah ln
                                                                           if (self->reminderButton.selected && ![Utility isEmptyCheck:self->savedReminderDict] && [[self->savedReminderDict objectForKey:@"PushNotification"] boolValue]) {
                                                                               
                                                                               [self->resultDict setObject:[[responseDictionary objectForKey:@"Details"] objectForKey:@"id"] forKey:@"id"];
                                                                               
                                                                               NSMutableDictionary *extraData = [[NSMutableDictionary alloc] init];
                                                                               [extraData setObject:self->resultDict forKey:@"selectedGoalDict"];
                                                                               [extraData setObject:self->_valuesArray forKey:@"valuesArray"];
                                                                               
                                                                               
                                                                               //                                                                               if (SYSTEM_VERSION_LESS_THAN(@"10")) {   //ah ln1
                                                                               [SetReminderViewController setOldLocalNotificationFromDictionary:self->savedReminderDict ExtraData:extraData FromController:(NSString *)@"Goal" Title:self->titleTextView.text Type:@"Goal" Id:[[self->_selectedGoalDict objectForKey:@"id"] intValue]];
                                                                               
                                                                               //                                                                               } else {
                                                                               //                                                                                   [SetReminderViewController setLocalNotificationFromDictionary:savedReminderDict ExtraData:extraData FromController:(NSString *)@"Goal" Title:titleTextView.text Type:@"Goal" Id:[[_selectedGoalDict objectForKey:@"id"] intValue]];
                                                                               //                                                                               };
                                                                           }
                                                                           [self.navigationController popViewControllerAnimated:YES];
                                                                           //                                                                           [self dismissViewControllerAnimated:YES completion:nil];
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


//chayan 23/10/2017
-(void) saveDataMultiPart {
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
        
        //change to save goalVal ids
        if (![Utility isEmptyCheck:[resultDict objectForKey:@"GoalValueData"]]) {
            NSRange hashRange = [[resultDict objectForKey:@"GoalValueData"] rangeOfString:@"###"];
            if (hashRange.location == NSNotFound) {
                NSArray *goalValArr = [[resultDict objectForKey:@"GoalValueData"] componentsSeparatedByString:@","];
                [resultDict setObject:[goalValArr componentsJoinedByString:@"###,"] forKey:@"GoalValueData"];
            }
        }
        //end
        
        
        [resultDict setObject:titleTextView.text forKey:@"Name"];
        
        //        NSArray *subViewArray = [mainStackView subviews];
        NSMutableArray *ansArr = [[NSMutableArray alloc]init];
        NSArray *ansArray = [_selectedGoalDict objectForKey:@"AnswerDetails"];
        
        for (int i = 0; i < questionArray.count; i++) {
            UITextView *textView = (UITextView*)[self.view viewWithTag:i+1001];
            
            if ([textView isKindOfClass:[UITextView class]] && (textView.tag == quesTag)) {
                NSMutableDictionary *ansDict = [[NSMutableDictionary alloc]init];
                if (![Utility isEmptyCheck:ansArray] && ansArray.count > 0 && ![Utility isEmptyCheck:[[ansArray objectAtIndex:i] objectForKey:@"id"]])
                    [ansDict setObject:[[ansArray objectAtIndex:i] objectForKey:@"id"] forKey:@"id"];
                else
                    [ansDict setObject:[NSNumber numberWithInt:0] forKey:@"id"];
                
                if (![Utility isEmptyCheck:[_selectedGoalDict objectForKey:@"id"]])
                    [ansDict setObject:[_selectedGoalDict objectForKey:@"id"] forKey:@"GoalId"];
                else
                    [ansDict setObject:[NSNumber numberWithInt:0] forKey:@"GoalId"];
                
                [ansDict setObject:[[questionArray objectAtIndex:i] objectForKey:@"id"] forKey:@"MotivationQuestionId"];
                NSLog(@"%@",textView.accessibilityHint);
                [ansDict setObject:textView.accessibilityHint forKey:@"Answer"];
                [ansDict setObject:[[questionArray objectAtIndex:i] objectForKey:@"Question"] forKey:@"Question"];
                [ansArr addObject:ansDict];
            }
        }
        if (ansArr.count > 0) {
            [resultDict setObject:ansArr forKey:@"AnswerDetails"];
        }
        
        [resultDict setObject:@"" forKey:@"UploadPictureImgBase64"];

        
        if ([Utility isEmptyCheck:[resultDict objectForKey:@"IsCreatedUpdated"]]) {    //ah ac2
            [resultDict setObject:[NSNumber numberWithBool:NO] forKey:@"IsCreatedUpdated"];
        }
        if ([Utility isEmptyCheck:[resultDict objectForKey:@"AnswerDetails"]]) {    //ah ac2
            [resultDict setObject:[NSArray new] forKey:@"AnswerDetails"];
        }
        if ([Utility isEmptyCheck:[resultDict objectForKey:@"GoalActionDetails"]]) {    //ah ac2
            [resultDict setObject:[NSArray new] forKey:@"GoalActionDetails"];
        }
        if ([Utility isEmptyCheck:[resultDict objectForKey:@"QuestionDetails"]]) {    //ah ac2
            [resultDict setObject:[NSArray new] forKey:@"QuestionDetails"];
        }
        
        //        [resultDict setObject:@"" forKey:@"Song"];
        
        
        NSError *error;
        
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults objectForKey:@"UserID"] forKey:@"UserID"];
        [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"AbbbcSessionId"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"AbbbcUserId"];
        [mainDict setObject:resultDict forKey:@"model"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        NSLog(@"%@",jsonString);
        ProgressBarViewController *controller=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ProgressBar"];
        controller.delegate=self;
        controller.apiName=@"AddUpdateGoalAPIWithPhoto";
        controller.appendString=@"";
        controller.jsonString=jsonString;
        controller.chosenImage=chosenImage;
        controller.modalPresentationStyle = UIModalPresentationCustom;
        [self presentViewController:controller animated:YES completion:nil];
    }else{
        [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
    }
    
}




-(void) deleteGoal {
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
        [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:[_selectedGoalDict objectForKey:@"id"] forKey:@"GoalID"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"DeleteGoalAPI" append:@"" forAction:@"POST"];
        
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
                                                                           [self.navigationController popViewControllerAnimated:YES];
                                                                           //                                                                           [self dismissViewControllerAnimated:YES completion:nil];
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
- (void) getGoalValue {     //ahln
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!self->contentView || ![self->contentView isDescendantOfView:self.view]) {
                //                [contentView removeFromSuperview];
//                contentView = [Utility activityIndicatorView:self];
            }
            //            contentView = [Utility activityIndicatorView:self];
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
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetGoalValueListAPI" append:@"" forAction:@"POST"];
        
        NSURLSessionDataTask * dataTask =[achieveSession dataTaskWithRequest:request
                                                           completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                               dispatch_async(dispatch_get_main_queue(),^ {
                                                                   //                                                                 if (contentView) {
                                                                   //                                                                     [contentView removeFromSuperview];
                                                                   //                                                                 }
                                                                   if(error == nil)
                                                                   {
                                                                       NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                       NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                       
                                                                       if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDictionary] && [[responseDictionary objectForKey:@"SuccessFlag"] boolValue]) {
                                                                           self->_valuesArray = [responseDictionary objectForKey:@"Details"];
                                                                           for (UIButton *button in self->goalValuesStackView.subviews) {
                                                                               [self->goalValuesStackView removeArrangedSubview:button];
                                                                               [button removeFromSuperview];
                                                                           }
                                                                           for (NSDictionary *temp in self->_valuesArray) {
                                                                               UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                                                                               
                                                                               [button addTarget:self action:@selector(goalValuesTapped:) forControlEvents:UIControlEventTouchUpInside];
                                                                               [button setTitle:[temp objectForKey:@"value"] forState:UIControlStateNormal];
                                                                               button.tag =[[temp objectForKey:@"id"] integerValue];
                                                                               button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                                                                               button.titleLabel.font =[UIFont fontWithName:@"Raleway-Medium" size:17];
                                                                               [button setTitleColor:squadMainColor forState:UIControlStateNormal];
                                                                               [button setBackgroundColor:[UIColor whiteColor]];
                                                                               [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
                                                                               [button setSelected:false];
                                                                               [self makeBorder:button mainColor:YES];
                                                                               
                                                                               [self->goalValuesStackView addArrangedSubview:button];
                                                                           }
                                                                           [self.view layoutIfNeeded];
                                                                       }
                                                                       
                                                                       //                                                                     }else{
                                                                       //                                                                         [Utility msg:[responseDictionary objectForKey:@"ErrorMessage"] title:@"Error !" controller:self haveToPop:NO];
                                                                       //                                                                         return;
                                                                       //                                                                     }
                                                                       
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
#pragma mark - ReminderDelegate
-(void) reminderSettingsValue:(NSMutableDictionary *)reminderDict {
    NSLog(@"rem %@",reminderDict);
    isChanged = YES;
    reminderButton.selected = true;
    [Utility startFlashingbutton:saveButton];
    [Utility startFlashingbutton:doneButton];

    savedReminderDict = reminderDict;   //ah ln
    [resultDict addEntriesFromDictionary:reminderDict];
    [_selectedGoalDict addEntriesFromDictionary:reminderDict];
    [self prepareReminderView];
}
-(void) cancelReminder {
    if ([resultDict objectForKey:@"FrequencyId"] != nil) {
        
    } else {
        reminderButton.selected = false;
//        [setReminderSwitch setOn:NO];
        [resultDict removeObjectForKey:@"FrequencyId"];
    }
    [self prepareReminderView];
}
#pragma mark - TableView Delegate & Datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *actionArray = [_selectedGoalDict objectForKey:@"GoalActionDetails"];
    if (isActionExapnd) {
        if(![Utility isEmptyCheck:actionArray]){
            return actionArray.count;
        }else{
            return 0;
        }
    }else{
         return 0;
    }
   
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *CellIdentifier = @"VisionGoalActionTableViewCell";
    VisionGoalActionTableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[VisionGoalActionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSArray *goalDetailsArr = [_selectedGoalDict objectForKey:@"GoalActionDetails"];
    if (![Utility isEmptyCheck:goalDetailsArr] && indexPath.row < goalDetailsArr.count) {
        //data
        cell.goalLabel.text = ![Utility isEmptyCheck:[[goalDetailsArr objectAtIndex:indexPath.row] objectForKey:@"Name"]]?[[@"" stringByAppendingFormat:@"%@",[[goalDetailsArr objectAtIndex:indexPath.row] objectForKey:@"Name"]] capitalizedString]:@"";
        
        cell.goalLabel.textColor = [UIColor colorWithRed:88/255.0f green:88/255.0f blue:88/255.0f alpha:1.0f];
        float cellAlpha;
        UIImage *placeholderImage;
        BOOL lastRem = [[[goalDetailsArr objectAtIndex:indexPath.row] objectForKey:@"LastReminderStatus"] boolValue];
        if (lastRem) {
            placeholderImage = [UIImage imageNamed:@"ok.png"];
            cellAlpha = 0.4;
        } else {
            placeholderImage = [UIImage imageNamed:@"ok_uncheck.png"];
            cellAlpha = 1.0;
        }
        if (![Utility isEmptyCheck:[[goalDetailsArr objectAtIndex:indexPath.row] objectForKey:@"Picture"]]) {
//            [cell.goalImageView sd_setImageWithURL:[NSURL URLWithString:[[goalDetailsArr objectAtIndex:indexPath.row] objectForKey:@"Picture"]] placeholderImage:placeholderImage options:SDWebImageScaleDownLargeImages];
            [cell.goalImageButton sd_setImageWithURL:[NSURL URLWithString:[[goalDetailsArr objectAtIndex:indexPath.row] objectForKey:@"Picture"]] forState:UIControlStateNormal placeholderImage:placeholderImage options:SDWebImageScaleDownLargeImages];
        } else {
//            cell.goalImageView.image = placeholderImage;
            [cell.goalImageButton setImage:placeholderImage forState:UIControlStateNormal];
        }
        cell.goalImageButton.layer.cornerRadius = cell.goalImageButton.frame.size.height/2;
        cell.goalImageButton.clipsToBounds = YES;
        
        NSDateFormatter *df = [NSDateFormatter new];
        [df setDateFormat:@"yyyy-MM-dd"];
        NSString *dateStr = [Utility getDateOnly:[@"" stringByAppendingFormat:@"%@",[[goalDetailsArr objectAtIndex:indexPath.row] objectForKey:@"CreatedAt"]]];
        NSDate *dateS = [df dateFromString:dateStr];
        [df setDateFormat:@"dd/MM/yy"];
        [cell.createdDateButton setTitle:[df stringFromDate:dateS] forState:UIControlStateNormal];
        cell.goalLabel.alpha = cellAlpha;
        [cell.createdDateButton setAlpha:cellAlpha];
        
    }
    
    return cell;
    
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    isFirstTime = true;
    NSArray *goalDetailsArr = [_selectedGoalDict objectForKey:@"GoalActionDetails"];
    
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(Id == %@)", [[goalDetailsArr objectAtIndex:indexPath.row] objectForKey:@"Id"]];
//    NSArray *filteredSessionCategoryArray = [actionArray filteredArrayUsingPredicate:predicate];
    NSDictionary *selectedDict = [goalDetailsArr objectAtIndex:indexPath.row];
//    if (filteredSessionCategoryArray.count > 0) {
//        selectedDict = [filteredSessionCategoryArray objectAtIndex:0];
//
//    }
    
    AddActionViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AddAction"];
//    controller.goalListArray = [goalListArray mutableCopy];
    //        controller.selectedGoal = [goalListArray objectAtIndex:indexPath.section];
    controller.actionSelectedDict = [selectedDict mutableCopy];
    if (![Utility isEmptyCheck:_buddyDict]) {
        controller.buddyDict = _buddyDict;
    }
    [self.navigationController pushViewController:controller animated:YES];
}
#pragma mark - Dropdown Delegate
-(void) dropdownSelected:(NSString *)selectedValue sender:(UIButton *)sender type:(NSString *)type{
//    NSLog(@"selv %@",selectedValue);
//    [sender setTitle:selectedValue forState:UIControlStateNormal];
//    if (sender == goalValuesButton) {
//
//    }
}
- (void) didSelectAnyDropdownOption:(NSString *)type data:(NSDictionary *)selectedData{
    NSLog(@"ty %@ \ndata %@",type,selectedData);
    isChanged = YES;
    [Utility startFlashingbutton:saveButton];
    [Utility startFlashingbutton:doneButton];
    if ([type caseInsensitiveCompare:@"Category"] == NSOrderedSame) {
        [categoryButton setTitle:[selectedData objectForKey:@"CategoryName"] forState:UIControlStateNormal];
        [resultDict setObject:[selectedData objectForKey:@"id"] forKey:@"CategoryId"];
    }
}
- (void) didSelectAnyDropdownOptionMultiSelect:(NSString *)type data:(NSDictionary *)selectedData isAdd:(BOOL)isAdd {
    isChanged = YES;
    [Utility startFlashingbutton:saveButton];
    [Utility startFlashingbutton:doneButton];
    if ([type caseInsensitiveCompare:@"goalValue"] == NSOrderedSame) {
        NSString *title = [goalValuesButton currentTitle];
        if (![Utility isEmptyCheck:selectedData] && selectedData.count > 0) {   //ah goal
            if ([title caseInsensitiveCompare:@"Select Values"] != NSOrderedSame) {
                if (isAdd) {
                    [goalValuesButton setTitle:[NSString stringWithFormat:@"%@, %@",title,[selectedData objectForKey:@"value"]] forState:UIControlStateNormal];
                    NSString *ids = [resultDict objectForKey:@"GoalValueData"];
                    [resultDict setObject:[NSString stringWithFormat:@"%@,%@",ids,[selectedData objectForKey:@"id"]] forKey:@"GoalValueData"];
                } else {
                    NSArray *titleArr = [title componentsSeparatedByString:@", "];
                    NSMutableArray *titleMutableArr = [titleArr mutableCopy];
                    for (int i = 0; i < titleMutableArr.count; i++) {
                        if ([titleMutableArr containsObject:[selectedData objectForKey:@"value"]]) {
                            [titleMutableArr removeObject:[selectedData objectForKey:@"value"]];
                        }
                    }
                    if (titleMutableArr.count > 0)
                        [goalValuesButton setTitle:[titleMutableArr componentsJoinedByString:@", "] forState:UIControlStateNormal];
                    else
                        [goalValuesButton setTitle:@"Select Values" forState:UIControlStateNormal];
                    
                    NSString *ids = [resultDict objectForKey:@"GoalValueData"];
                    NSArray *idArr = [ids componentsSeparatedByString:@","];
                    NSMutableArray *idMutableArr = [idArr mutableCopy];
                    for (int i = 0; i < idMutableArr.count; i++) {
                        if ([[idMutableArr objectAtIndex:i] intValue] == [[selectedData objectForKey:@"id"] intValue]) {
                            [idMutableArr removeObjectAtIndex:i];
                        }
                    }
                    if (idMutableArr.count > 0)
                        [resultDict setObject:[idMutableArr componentsJoinedByString:@","] forKey:@"GoalValueData"];
                    else {
                        [resultDict setObject:@"" forKey:@"GoalValueData"];
                        [resultDict setObject:[NSArray new] forKey:@"GoalValuesMapDetails"];    //ah 27.3
                    }
                }
            } else {
                [goalValuesButton setTitle:[selectedData objectForKey:@"value"] forState:UIControlStateNormal];
                [resultDict setObject:[[selectedData objectForKey:@"id"] stringValue] forKey:@"GoalValueData"];
            }
        }
    }
}
#pragma  mark - DatePickerViewControllerDelegate

-(void)didSelectDate:(NSDate *)date{
    isChanged = YES;
    [Utility startFlashingbutton:saveButton];
    [Utility startFlashingbutton:doneButton];
    if (date) {
        static NSDateFormatter *dateFormatter;
        dateFormatter = [NSDateFormatter new];
//        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
        selectedDate = date;
        [dateFormatter setDateFormat:@"dd/MM/yyyy"];
        NSString *dateString = [dateFormatter stringFromDate:date];
        [dueDateButton setTitle:dateString forState:UIControlStateNormal];
        
//        NSCalendar *cal = [NSCalendar currentCalendar];
//        NSDate *newDate = [cal dateByAddingUnit:NSCalendarUnitMonth value:1 toDate:[NSDate date] options:0];
//        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
        NSString *currentDateStr = [dateFormatter stringFromDate:date];
        [resultDict setObject:currentDateStr forKey:@"DueDate"];
    }
}
#pragma mark - SongListDelegate
- (void) getSelectedSongName:(NSString *)name Url:(NSString *)songUrlStr {
    NSLog(@"su %@",songUrlStr);
//    [selectSongButton setAccessibilityHint:songUrlStr];
//    [selectSongButton setTitle:name forState:UIControlStateNormal];
//    [resultDict setObject:songUrlStr forKey:@"Song"];      //ah song
    
    isChanged = YES;
    [Utility startFlashingbutton:saveButton];
    [Utility startFlashingbutton:doneButton];

    [selectSongButton setAccessibilityHint:songUrlStr];
    [selectSongButton setTitle:name forState:UIControlStateNormal];
    NSString *saveSongDataStr = [NSString stringWithFormat:@"%@*##*%@",songUrlStr,name];
    [resultDict setObject:saveSongDataStr forKey:@"Song"];      //ah 4.5
    [_selectedGoalDict setObject:saveSongDataStr forKey:@"Song"];
    
}
#pragma mark - SportifyDelegate
-(void) sportifySelSongName:(NSString *)name Url:(NSString *)songUrlStr{
    //song name from spotify
    NSLog(@"song song song %@",songUrlStr);
    
    isChanged = YES;
    [Utility startFlashingbutton:saveButton];
    [Utility startFlashingbutton:doneButton];
    
    [selectSongButton setAccessibilityHint:songUrlStr];
    [selectSongButton setTitle:name forState:UIControlStateNormal];
    NSString *saveSongDataStr = [NSString stringWithFormat:@"%@*##*%@",songUrlStr,name];
    [resultDict setObject:saveSongDataStr forKey:@"Song"];      //ah 4.5
    [_selectedGoalDict setObject:saveSongDataStr forKey:@"Song"];
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
        
        
        
        //        if (!self.sPlayer) {
        //            self.sPlayer = [SPTAudioStreamingController sharedInstance];
        //            self.sPlayer.delegate = self;
        //            self.sPlayer.playbackDelegate = self;
        //        }
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
-(void)doneWithFirstResponder{
    [self.view endEditing:YES];
}
-(BOOL) validationCheck {
    BOOL isValid = NO;
    NSString *titleStr = titleTextView.text;
    
    if (titleStr.length < 1 || [titleStr isEqualToString:@"ADD GOAL"]) {
        [Utility msg:@"Please enter Goal Name." title:@"Oops!" controller:self haveToPop:NO];
        return isValid;
    } else if ([[resultDict objectForKey:@"CategoryId"] intValue] < 0) {        //ah ux3
        [Utility msg:@"Please select Category." title:@"Oops!" controller:self haveToPop:NO];
        return isValid;
    } else if (!reminderButton.selected) {
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:nil
                                              message:@"Would you like to set a reminder to help you stay accountable and achieve your goal?"
                                              preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:@"Yes"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action) {
//                                       [self->setReminderSwitch setOn:YES];
                                       [self setReminderPressed:self->reminderButton];
                                   }];
        UIAlertAction *cancelAction = [UIAlertAction
                                       actionWithTitle:@"No"
                                       style:UIAlertActionStyleCancel
                                       handler:^(UIAlertAction *action)
                                       {
                                           [self saveDataMultiPart];
                                       }];
        [alertController addAction:okAction];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
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
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    controller.delegate = self;
    controller.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:controller animated:YES completion:NULL];
}

//-(void)writeImageInDocumentsDirectory:(UIImage *)image{
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    NSString *savedImagePath = [documentsDirectory stringByAppendingPathComponent:@"savedImage.png"];
//    NSData *imageData = UIImagePNGRepresentation(image);
//    [imageData writeToFile:savedImagePath atomically:NO];
//}

-(void) prepareView {
    [self.view endEditing:YES];
    if (![Utility isEmptyCheck:_selectedGoalDict] && _selectedGoalDict.count > 0 && !isEdit) {
        //view
        NSLog(@"view");
//        [self updateProgressView];
//        titleTextView.textColor = [UIColor darkGrayColor];
        
        titleTextView.text = ![Utility isEmptyCheck:[_selectedGoalDict objectForKey:@"Name"]]?[[@"" stringByAppendingFormat:@"%@",[_selectedGoalDict objectForKey:@"Name"]]capitalizedString]:@"";
        titleTextViewHeightConstraint.constant = titleTextView.contentSize.height;
        titleTextView.userInteractionEnabled = NO;
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
        NSDate *selectedDateApi = [formatter dateFromString:[_selectedGoalDict objectForKey:@"DueDate"]];
        if ([Utility isEmptyCheck:selectedDateApi]) {
            [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS"];
            selectedDateApi = [formatter dateFromString:[_selectedGoalDict objectForKey:@"DueDate"]];
        }
        if ([Utility isEmptyCheck:selectedDateApi]) {
            [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSSZZZZZ"];
            selectedDateApi = [formatter dateFromString:[_selectedGoalDict objectForKey:@"DueDate"]];
        }
        [formatter setDateFormat:@"dd/MM/yyyy"];
        NSString *currentButtonDateStr = [formatter stringFromDate:selectedDateApi];
        
        [dueDateButton setTitle:currentButtonDateStr forState:UIControlStateNormal];
        dueDateButton.userInteractionEnabled = NO;
        selectedDate = selectedDateApi;
        if ([[formatter dateFromString:[formatter stringFromDate:[NSDate date]]] isEarlierThanOrEqualTo:[formatter dateFromString:currentButtonDateStr]]) {
            [setReminderSwitch setOnTintColor:[UIColor colorWithRed:(76/255.0f) green:(217/255.0f) blue:(100/255.0f) alpha:1.0f]];
        }
        if (![Utility isEmptyCheck:[_selectedGoalDict objectForKey:@"Picture"]]) {
            NSString *imgUrlStr = [[_selectedGoalDict objectForKey:@"Picture"] stringByReplacingOccurrencesOfString:@"thumbnails/" withString:@""];

            [goalImageView sd_setImageWithURL:[NSURL URLWithString:imgUrlStr] placeholderImage:[UIImage imageNamed:@"EXERCISE-picture-coming.jpg"] options:SDWebImageScaleDownLargeImages completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                
                CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
                if (image) {    //ah 24.3
                    CGFloat imageViewHeight = image.size.height/image.size.width * screenWidth;
                    self->imageViewHeightConstraint.constant = imageViewHeight;
                }
                
            }];
            goalImageView.hidden = false;
            uploadImageButton.hidden = true;
            changePictureView.hidden = NO;
        } else {
            goalImageView.image = [UIImage imageNamed:@"upload_image.png"];
            goalImageView.hidden = true;
            uploadImageButton.hidden = false;
            changePictureView.hidden = YES;
        }
        uploadImageButton.userInteractionEnabled = NO;
        
        NSArray *ansArray = [_selectedGoalDict objectForKey:@"AnswerDetails"];
        if ([Utility isEmptyCheck:ansArray] || ansArray.count == 0) {
            NSArray *subviews = [mainStackView subviews];
            
            for (UIView *subview in subviews) {
                if ([subview isKindOfClass:[AddGoalQuestion class]]) {
                    subview.hidden = YES;
                }
            }
        } else {
            for (int i = 0; i < ansArray.count; i++) {
                int tag = [[[ansArray objectAtIndex:i] objectForKey:@"MotivationQuestionId"] intValue];
                AddGoalQuestion *addGoalQuestion = (AddGoalQuestion *)[self.view viewWithTag:tag+101];
                
                if ([addGoalQuestion isKindOfClass:[AddGoalQuestion class]]) {
                    if (![Utility isEmptyCheck:[[ansArray objectAtIndex:i] objectForKey:@"Answer"]]) {
                        addGoalQuestion.answerTextView.attributedText = [Utility converHtmltotext:[[ansArray objectAtIndex:i] objectForKey:@"Answer"]];
                        addGoalQuestion.answerTextView.accessibilityHint = [[ansArray objectAtIndex:i] objectForKey:@"Answer"];
                        addGoalQuestion.answerTextView.userInteractionEnabled = NO;
                        addGoalQuestion.answerTextViewHeight.constant = addGoalQuestion.answerTextView.contentSize.height;
                        if (![detailsPlaceholderArr containsObject:addGoalQuestion.answerTextView.text]) {
                            addGoalQuestion.answerTextView.textColor = [[Utility colorWithHexString:@"333333"]colorWithAlphaComponent:1.0];

                        }else{
                            addGoalQuestion.answerTextView.textColor = [[Utility colorWithHexString:@"333333"]colorWithAlphaComponent:0.5];

                        }
                        if (showButton.tag == 1) {
                            showButton.tag = 0;
                            [otherImageView setImage:[UIImage imageNamed:@"fp_up_arr.png"]];
                            showButton.selected = false;
                        }
                        
                        addGoalQuestion.hidden = showButton.isSelected;
                    } else {
                        addGoalQuestion.hidden = YES;
                    }
                }
            }
        }
    
        setReminderView.hidden = YES;
        goalValueView.hidden = showButton.isSelected;//YES
        categoryView.hidden = showButton.isSelected;//YES
        doneButton.hidden = NO;
        showHideView.hidden = YES;
        
        editButton.hidden = NO;
        editView.hidden = YES;
        copyButton.hidden = YES;
        
        pictureView.hidden = showButton.isSelected;
        songView.hidden = showButton.isSelected;
        privacyView.hidden = showButton.isSelected;
        
        privacyView.userInteractionEnabled = false;
        setReminderView.userInteractionEnabled = false;
        songView.userInteractionEnabled = false;
        pictureView.userInteractionEnabled = false;
        saveCancelView.hidden = YES;
        
        if (![Utility isEmptyCheck:[_selectedGoalDict objectForKey:@"PushNotification"]] && ![Utility isEmptyCheck:[_selectedGoalDict objectForKey:@"Email"]] && ([[_selectedGoalDict objectForKey:@"PushNotification"] boolValue] || [[_selectedGoalDict objectForKey:@"Email"] boolValue])) {
//            [setReminderSwitch setOn:YES];
            reminderButton.selected = true;
        } else {
//            [setReminderSwitch setOn:NO];
            reminderButton.selected = false;
        }
        
        if (![Utility isEmptyCheck:[_selectedGoalDict objectForKey:@"Song"]]) {
            //play song
            NSError *error;
            //            if ([[NSFileManager defaultManager] fileExistsAtPath:[_selectedGoalDict objectForKey:@"Song"]]) {
            
            NSArray *songArr = [[_selectedGoalDict objectForKey:@"Song"] componentsSeparatedByString:@"*##*"];
            
            if (![Utility isEmptyCheck:songArr]) {
                if (songArr.count > 1) {
                    [selectSongButton setTitle:[songArr objectAtIndex:1] forState:UIControlStateNormal];
                }
                NSString *uri = [songArr objectAtIndex:0];
                if ([uri hasPrefix:@"spotify"]) {
                    [self playSongInSpotify:uri];
                } else {
                    player = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL URLWithString:[songArr objectAtIndex:0]] error:&error];
                    
                    if (!error) {
                        [player prepareToPlay];
                        [player play];
                    }
                }
                
            }
            
            //ah 4.5
//            player = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL URLWithString:[_selectedGoalDict objectForKey:@"Song"]] error:&error];
//            
//            if (!error) {
//                [player prepareToPlay];
//                [player play];
//            }
            //}
            
        }
        if (![Utility isEmptyCheck:[_selectedGoalDict objectForKey:@"Buddy_Privacy"]] && [[_selectedGoalDict objectForKey:@"Buddy_Privacy"]boolValue]) {
            privateButton.selected = true;
            publicButton.selected = false;
            [privateButton setBackgroundColor: squadMainColor];
            [publicButton setBackgroundColor: [UIColor whiteColor]];
        } else {
            privateButton.selected = false;
            publicButton.selected = true;
            [privateButton setBackgroundColor: [UIColor whiteColor]];
            [publicButton setBackgroundColor: squadMainColor];
        }
        if (![Utility isEmptyCheck:_buddyDict]) {
            editView.hidden = true;
            deleteButton.hidden = true;
            saveCancelView.hidden = true;
            setReminderView.hidden = true;
            CGRect fram = CGRectMake(0, 0, footerView.frame.size.width, 0);
            footerView.frame = fram;
            footerView.hidden = true;
            if (![Utility isEmptyCheck:[_selectedGoalDict objectForKey:@"Picture"]]) {
                uploadImageButton.hidden = true;
                changePictureView.hidden = true;
            }else{
                pictureView.hidden = true;
            }
            [self.view setNeedsLayout];
            [self.view layoutIfNeeded];
        }
    } else if (![Utility isEmptyCheck:_selectedGoalDict] && _selectedGoalDict.count > 0 && isEdit) {
        //edit
        NSLog(@"edit");
        ismaniFestExpand = true;
        mainfestGoalArrButton.selected = true;
        
//        [self updateProgressView];
//        titleTextView.textColor = [UIColor darkGrayColor];
        
        editButton.hidden = YES;
        editView.hidden = YES;
        copyButton.hidden = NO;
        
        setReminderView.hidden = YES;
//        goalValueView.hidden = showButton.isSelected;//NO
//        categoryView.hidden = showButton.isSelected;//NO
        doneButton.hidden = NO;
        songView.hidden = showButton.isSelected;;
        showHideView.hidden = YES;
        pictureView.hidden = showButton.isSelected;
        privacyView.hidden = showButton.isSelected;
        
        privacyView.userInteractionEnabled = YES;
        pictureView.userInteractionEnabled = YES;
        songView.userInteractionEnabled = YES;
        setReminderView.userInteractionEnabled = YES;
        [player pause];
        
        saveCancelView.hidden = NO;    //aha
        
        if (![Utility isEmptyCheck:[_selectedGoalDict objectForKey:@"Picture"]]) {
            changePictureView.hidden = NO;
            uploadImageButton.hidden = true;
            goalImageView.hidden = false;
        } else {
            changePictureView.hidden = YES;
            uploadImageButton.hidden = false;
            goalImageView.hidden = true;
        }
        
        titleTextView.userInteractionEnabled = YES;
        dueDateButton.userInteractionEnabled = YES;
        uploadImageButton.userInteractionEnabled = YES;
        
        NSArray *ansArray = [_selectedGoalDict objectForKey:@"AnswerDetails"];
        if ([Utility isEmptyCheck:ansArray] || ansArray.count == 0) {
            NSArray *subviews = [mainStackView subviews];
            
            for (UIView *subview in subviews) {
                if ([subview isKindOfClass:[AddGoalQuestion class]]) {
                    subview.hidden = NO;
                }
            }
        } else {
            for (int i = 0; i < ansArray.count; i++) {
                int tag = [[[ansArray objectAtIndex:i] objectForKey:@"MotivationQuestionId"] intValue];
                AddGoalQuestion *addGoalQuestion = (AddGoalQuestion *)[self.view viewWithTag:tag+101];
                
                if ([addGoalQuestion isKindOfClass:[AddGoalQuestion class]]) {
                    if (![Utility isEmptyCheck:[[ansArray objectAtIndex:i] objectForKey:@"Answer"]]) {
                        addGoalQuestion.answerTextView.attributedText = [Utility converHtmltotext:[[ansArray objectAtIndex:i] objectForKey:@"Answer"]];
                        addGoalQuestion.answerTextViewHeight.constant = addGoalQuestion.answerTextView.contentSize.height;
                        if (![detailsPlaceholderArr containsObject:addGoalQuestion.answerTextView.text]) {
                            addGoalQuestion.answerTextView.textColor = [[Utility colorWithHexString:@"333333"]colorWithAlphaComponent:1.0];
                        }else{
                            addGoalQuestion.answerTextView.textColor = [[Utility colorWithHexString:@"333333"]colorWithAlphaComponent:0.5];
                        }
                    }
                    addGoalQuestion.answerTextView.userInteractionEnabled = YES;
                    addGoalQuestion.hidden = showButton.isSelected;
                }
            }
        }
        
        NSDictionary *selectedDict = [self getDictByValue:categoryArray value:[_selectedGoalDict objectForKey:@"CategoryId"] type:@"id"];
        for (UIButton *button in categoryStackView.subviews) {
            if (button.tag == [[selectedDict objectForKey:@"id"] intValue]) {
                [button setBackgroundColor:squadMainColor];
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [button setSelected:true];
            } else {
                [button setBackgroundColor:[UIColor whiteColor]];
                [button setTitleColor:squadMainColor forState:UIControlStateNormal];
                [button setSelected:false];
            }
        }
        
        [categoryButton setTitle:[selectedDict objectForKey:@"CategoryName"] forState:UIControlStateNormal];
        
        if (![Utility isEmptyCheck:[_selectedGoalDict objectForKey:@"PushNotification"]] && ![Utility isEmptyCheck:[_selectedGoalDict objectForKey:@"Email"]] && ([[_selectedGoalDict objectForKey:@"PushNotification"] boolValue] || [[_selectedGoalDict objectForKey:@"Email"] boolValue])) {
            savedReminderDict = _selectedGoalDict;   //ah ln
//            [setReminderSwitch setOn:YES];
            reminderButton.selected = true;
        } else {
//            [setReminderSwitch setOn:NO];
            reminderButton.selected = false;
        }
        
        [resultDict addEntriesFromDictionary:_selectedGoalDict];
        
        if (![Utility isEmptyCheck:[_selectedGoalDict objectForKey:@"GoalValueData"]]) {
            NSArray *idsArr = [[_selectedGoalDict objectForKey:@"GoalValueData"] componentsSeparatedByString:@"###,"];
            NSMutableArray *selectedIds = [[NSMutableArray alloc]init];
            NSMutableArray *selectedTitles = [[NSMutableArray alloc]init];
            for (int i = 0; i < idsArr.count; i++) {    //ah 27.3
                //NSDictionary *selectedData = [self getDictByValue:_valuesArray value:[idsArr objectAtIndex:i] type:@"id"];
                
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(id == %d)", [[idsArr objectAtIndex:i] intValue]];
                NSArray *filteredSessionCategoryArray = [_valuesArray filteredArrayUsingPredicate:predicate];
                NSDictionary *selectedData;
                if (filteredSessionCategoryArray.count > 0) {
                    selectedData = [filteredSessionCategoryArray objectAtIndex:0];
                }
                
                if (selectedData.count > 0) {
                    [selectedIds addObject:[selectedData objectForKey:@"id"]];
                    [selectedTitles addObject:[selectedData objectForKey:@"value"]];
                    for (UIButton *button in goalValuesStackView.subviews) {
                        if (button.tag == [[selectedData objectForKey:@"id"]intValue]) {
                            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                            [button setBackgroundColor:squadMainColor];
                            [button setSelected:true];
                            break;
                        }
                    }
                }
            }
            [goalValuesButton setTitle:[selectedTitles componentsJoinedByString:@", "] forState:UIControlStateNormal];
            [resultDict setObject:[selectedIds componentsJoinedByString:@","] forKey:@"GoalValueData"];
        } else if (![Utility isEmptyCheck:[_selectedGoalDict objectForKey:@"GoalValuesMapDetails"]]) {  //ah 27.3
            NSArray *goalValuesMapDetails = [_selectedGoalDict objectForKey:@"GoalValuesMapDetails"];
            NSString *idStr;
            for (int i = 0; i < goalValuesMapDetails.count; i++) {
                if (![Utility isEmptyCheck:idStr]) {
                    idStr = [NSString stringWithFormat:@"%@###,%@",idStr,[[goalValuesMapDetails objectAtIndex:i] objectForKey:@"GoalValueId"]];
                } else {
                    idStr = [NSString stringWithFormat:@"%@",[[goalValuesMapDetails objectAtIndex:i] objectForKey:@"GoalValueId"]];
                }
            }
            
            NSArray *idsArr = [idStr componentsSeparatedByString:@"###,"];
            NSMutableArray *selectedIds = [[NSMutableArray alloc]init];
            NSMutableArray *selectedTitles = [[NSMutableArray alloc]init];
            for (int i = 0; i < idsArr.count; i++) {
                
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(id == %d)", [[idsArr objectAtIndex:i] intValue]];
                NSArray *filteredSessionCategoryArray = [_valuesArray filteredArrayUsingPredicate:predicate];
                NSDictionary *selectedData;
                if (filteredSessionCategoryArray.count > 0) {
                    selectedData = [filteredSessionCategoryArray objectAtIndex:0];
                }
                
//                NSDictionary *selectedData = [self getDictByValue:_valuesArray value:[idsArr objectAtIndex:i] type:@"id"];
                if (selectedData.count > 0) {
                    [selectedIds addObject:[selectedData objectForKey:@"id"]];
                    [selectedTitles addObject:[selectedData objectForKey:@"value"]];
                    for (UIButton *button in goalValuesStackView.subviews) {
                        if (button.tag == [[selectedData objectForKey:@"id"]intValue]) {
                            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                            [button setBackgroundColor:squadMainColor];
                            [button setSelected:true];
                            break;
                        }
                    }
                }
            }
            [goalValuesButton setTitle:[selectedTitles componentsJoinedByString:@", "] forState:UIControlStateNormal];
            [resultDict setObject:[selectedIds componentsJoinedByString:@","] forKey:@"GoalValueData"];
        }
        
//        [resultDict addEntriesFromDictionary:_selectedGoalDict];
        if (![Utility isEmptyCheck:[_selectedGoalDict objectForKey:@"Buddy_Privacy"]] && [[_selectedGoalDict objectForKey:@"Buddy_Privacy"]boolValue]) {
            privateButton.selected = true;
            publicButton.selected = false;
            [privateButton setBackgroundColor: squadMainColor];
            [publicButton setBackgroundColor: [UIColor whiteColor]];
        } else {
            privateButton.selected = false;
            publicButton.selected = true;
            [privateButton setBackgroundColor: [UIColor whiteColor]];
            [publicButton setBackgroundColor: squadMainColor];
        }
    } else {
        //add
        NSLog(@"add");
        goalValueView.hidden = YES;
        categoryView.hidden = YES;
        songView.hidden = YES;
        showHideView.hidden = YES;
        pictureView.hidden = YES;
        privacyView.hidden = YES;
        
        NSArray *subviews = [mainStackView subviews];
        for (UIView *subview in subviews) {
            if ([subview isKindOfClass:[AddGoalQuestion class]]) {
                subview.hidden = YES;
            }
        }
        
        NSCalendar *cal = [NSCalendar currentCalendar];
        NSDate *newDate = [cal dateByAddingUnit:NSCalendarUnitMonth value:1 toDate:[NSDate date] options:0];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSSZZZZZ"];     //2017-03-06T10:38:18.7877+00:00
        NSString *currentDateStr = [formatter stringFromDate:newDate];
        NSString *newCurrentDateStr = [formatter stringFromDate:[NSDate date]];
        
        [resultDict setObject:[NSNumber numberWithInt:0] forKey:@"id"];
        titleTextView.text = goalName;
        [resultDict setObject:@"" forKey:@"Name"];
        NSDictionary *selectedDict = [self getDictByValue:categoryArray value:@"Health" type:@"CategoryName"];
        if (![Utility isEmptyCheck:selectedDict]) {
            [categoryButton setTitle:[selectedDict objectForKey:@"CategoryName"] forState:UIControlStateNormal];
            for (UIButton *button in categoryStackView.subviews) {
                if (button.tag == [[selectedDict objectForKey:@"id"] intValue]) {
                    [button setBackgroundColor:squadMainColor];
                    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    [button setSelected:true];
                } else {
                    [button setBackgroundColor:[UIColor whiteColor]];
                    [button setTitleColor:squadMainColor forState:UIControlStateNormal];
                    [button setSelected:false];
                }
            }
            [resultDict setObject:[selectedDict objectForKey:@"id"] forKey:@"CategoryId"];
        }else{
            [resultDict setObject:[NSNumber numberWithInt:-1] forKey:@"CategoryId"];
        }
        
        [resultDict setObject:currentDateStr forKey:@"DueDate"];
        [resultDict setObject:@"" forKey:@"UploadPictureImgBase64"];
        [resultDict setObject:[defaults objectForKey:@"UserID"] forKey:@"CreatedBy"];
        [resultDict setObject:@"" forKey:@"GoalValueData"];
        [resultDict setObject:[NSArray new] forKey:@"AnswerDetails"];
        [resultDict setObject:[NSArray new] forKey:@"GoalActionDetails"];
        [resultDict setObject:currentDateStr forKey:@"reminder_till_date"];
        [resultDict setObject:newCurrentDateStr forKey:@"last_reminder_inserted_date"];
        [resultDict setObject:newCurrentDateStr forKey:@"CreatedAt"];
        [resultDict setObject:[NSNumber numberWithBool:NO] forKey:@"IsDeleted"];
        [resultDict setObject:[NSNumber numberWithBool:NO] forKey:@"Status"];
        [resultDict setObject:[NSNumber numberWithBool:NO] forKey:@"IsCreatedUpdated"];
        [resultDict setObject:[NSNumber numberWithBool:NO] forKey:@"Buddy_Privacy"];
//        [resultDict setObject:@"" forKey:@"Song"];      //ah song
        
        [formatter setDateFormat:@"dd/MM/yyyy"];
        NSString *currentButtonDateStr = [formatter stringFromDate:newDate];
        [dueDateButton setTitle:currentButtonDateStr forState:UIControlStateNormal];
        
        goalImageView.hidden = true;
        privateButton.selected = false;
        publicButton.selected = true;
        [privateButton setBackgroundColor: [UIColor whiteColor]];
        [publicButton setBackgroundColor: squadMainColor];
    }
    categoryView.hidden = true;
    goalValueView.hidden = true;
    if (!actionTable.isHidden) {
        [actionTable reloadData];
    }
    [self prepareReminderView];
    if (editMode) {
        editMode = false;
        isEdit = true;
        [self prepareView];
    }
    
    mainScroll.hidden = false;
}

-(NSDictionary *)getDictByValue:(NSArray *)filterArray value:(id)value type:(NSString *)type{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(%K == %@)",type, value];
    NSArray *filteredSessionCategoryArray = [filterArray filteredArrayUsingPredicate:predicate];
    if (filteredSessionCategoryArray.count > 0) {
        NSDictionary *dict = [filteredSessionCategoryArray objectAtIndex:0];
        return dict;
    }
    return  nil;
}
-(void)prepareReminderView{
    if (reminderButton.selected) {
        viewReminder.enabled = true;
        [viewReminder setTitle:@"View Reminder Settings" forState:UIControlStateNormal];
        [viewReminder setTitleColor:squadMainColor forState:UIControlStateNormal];
        viewReminder.alpha = 1.0;
        
    }else{
        viewReminder.enabled = false;
        [viewReminder setTitle:@"Set a Reminder" forState:UIControlStateNormal];
        [viewReminder setTitleColor:squadMainColor forState:UIControlStateNormal];
        viewReminder.alpha = 0.5;
        
    }
}
- (void) shouldPopOnBackButtonWithResponse:(void (^)(BOOL shouldPop))response {    //ah ux3
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
                                       [self doneTapped:nil];
                                       response(NO);
                                   }];
        UIAlertAction *cancelAction = [UIAlertAction
                                       actionWithTitle:@"Don't Save"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction *action)
                                       {
                                           response(YES);
                                       }];
        [alertController addAction:okAction];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    } else {
        response(YES);
    }
}
#pragma mark - UIImagePickerControllerDelegate methods

/*
 Open PECropViewController automattically when image selected.
 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    image =[Utility scaleImage:image width:image.size.width height:image.size.height];
//    goalImageView.image = image;
    chosenImage = [UIImage imageWithData:UIImageJPEGRepresentation(image, 0.2)];
    goalImageView.image = chosenImage;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat imageViewHeight = chosenImage.size.height/chosenImage.size.width * screenWidth;
    self->imageViewHeightConstraint.constant = imageViewHeight;
    changePictureView.hidden = NO;
    uploadImageButton.hidden = true;
    goalImageView.hidden = false;
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
            self->isChanged = YES;
            [Utility startFlashingbutton:self->saveButton];
            [Utility startFlashingbutton:self->doneButton];
            
        });
    }];
    //    userImageView.image = croppedImage;
    //    UIImage *image=[self scaleImage:croppedImage];
    
    croppedImage = [UIImage imageWithData:UIImageJPEGRepresentation(croppedImage, 0.2)];

    goalImageView.image = croppedImage;
    chosenImage = croppedImage;
    
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
    
    [controller dismissViewControllerAnimated:YES completion:^{
        dispatch_async(dispatch_get_main_queue(),^ {
            self->isChanged = YES;
            [Utility startFlashingbutton:self->saveButton];
            [Utility startFlashingbutton:self->doneButton];
            
        });
    }];}

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
    
    if (activeTextField !=nil) {
        CGRect aRect = mainScroll.frame;
        aRect.size.height -= kbSize.height;
        if (!CGRectContainsPoint(aRect, activeTextField.frame.origin) ) {
            [mainScroll scrollRectToVisible:activeTextField.frame animated:YES];
        }
    } else if (activeTextView !=nil) {
        CGRect aRect = self.view.frame;
        aRect.size.height -= kbSize.height;
        if (!CGRectContainsPoint(aRect, activeTextView.superview.frame.origin) ) {
            CGRect newRect = activeTextView.superview.frame;
            newRect.size.height = newRect.size.height + 8;
            [mainScroll scrollRectToVisible:newRect animated:YES];
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
#pragma mark - textField Delegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField == actionNameTextField) {
        [self addActionPessed:0];
        return NO;
    }
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    activeTextField = textField;
    isChanged = YES;
    [Utility startFlashingbutton:saveButton];
    [Utility startFlashingbutton:doneButton];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    activeTextField = nil;
}
#pragma mark - textView Delegate
- (void)textViewDidBeginEditing:(UITextView *)textView{
//    if (![textView isEqual:titleTextView]) {
//         [self.view endEditing:YES];
//    }
    
    activeTextView=textView;
    isChanged = YES;

    [Utility startFlashingbutton:saveButton];
    [Utility startFlashingbutton:doneButton];
}

- (void)textViewDidEndEditing:(UITextView *)textView{
   
    activeTextView=nil;
    if([textView isEqual:titleTextView] && titleTextView.text.length == 0){
        titleTextView.text = @"ADD GOAL";
        [titleTextView resignFirstResponder];
    }else if(![textView isEqual:titleTextView] && questiontextDetailsView.hidden){
//        [self.view endEditing:YES];
        AddGoalQuestion *addGoalQuestion = (AddGoalQuestion *)[textView viewWithTag:textView.tag].superview;
//        if (textView.contentSize.height >= 50) {
//            addGoalQuestion.answerTextViewHeight.constant = textView.contentSize.height;
//        } else {
//            addGoalQuestion.answerTextViewHeight.constant = 50;
//        }
        addGoalQuestion.answerTextViewHeight.constant = 50;
        NSArray *subviews = [mainStackView subviews];
        for (int i=0; i<subviews.count; i++) {
            if ([addGoalQuestion isKindOfClass:[AddGoalQuestion class]]) {
                if (addGoalQuestion.answerTextView.text.length == 0) {
                    addGoalQuestion.answerTextView.textColor = [[Utility colorWithHexString:@"333333"]colorWithAlphaComponent:0.5];
                    addGoalQuestion.answerTextView.text = detailsPlaceholderArr[(textView.tag-1)-1000];
                }
            }
        }
    }
}

- (BOOL)textView:(UITextView *)txtView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([txtView isEqual:titleTextView]) {
//        if (txtView.contentSize.height > titleTextViewHeightConstraint.constant) {
            titleTextViewHeightConstraint.constant = txtView.contentSize.height;
//        }
    }else if(questiontextDetailsView.hidden){
        AddGoalQuestion *addGoalQuestion = (AddGoalQuestion *)[txtView viewWithTag:txtView.tag].superview;
        if (txtView.contentSize.height >= 50) {
            addGoalQuestion.answerTextViewHeight.constant = txtView.contentSize.height;
        } else {
            addGoalQuestion.answerTextViewHeight.constant = 50;
        }
    }
    [self.view layoutIfNeeded];
    return YES;
}
- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    if([textView isEqual:titleTextView] && [textView.text caseInsensitiveCompare:@"ADD GOAL"] == NSOrderedSame){
        titleTextView.text = @"";
    }else if (![textView isEqual:titleTextView] && questiontextDetailsView.hidden) {
        [Utility removeCursor:textView];
        activeTextView = textView;
        [textView setInputAccessoryView:numberToolbar];
        if ([detailsPlaceholderArr containsObject:textView.text]) {
                textView.text = @"";
        }
        textView.textColor = [[Utility colorWithHexString:@"333333"]colorWithAlphaComponent:1];

        
//            NotesViewController *controller =[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NotesView"];
//            controller.notesDelegate = self;
//            controller.textView = textView;
//            if (![detailsPlaceholderArr containsObject:textView.text]) {
//                controller.htmlEditText = textView.accessibilityHint;
//            }
//            controller.modalPresentationStyle = UIModalPresentationCustom;
//            [self presentViewController:controller animated:NO completion:nil];
////            quesSaveView.hidden = false;
////            saveCancelView.hidden = true;
////            quesTextView.text = textView.text;
//            quesTag = (int)textView.tag;
////            [mainScroll setContentOffset:CGPointZero animated:YES];
////            if ([detailsPlaceholderArr containsObject:textView.text]) {
////                 quesTextView.textColor = [[Utility colorWithHexString:@"333333"]colorWithAlphaComponent:0.5];
////            }else{
////                 quesTextView.textColor = [[Utility colorWithHexString:@"333333"]colorWithAlphaComponent:1];
////            }
////            questiontextDetailsView.hidden = false;
////            [backButton setTitle:@"Close" forState:UIControlStateNormal];
    }else{
         if ([detailsPlaceholderArr containsObject:textView.text]) {
              quesTextView.text= @"";
         }
        quesTextView.textColor = [[Utility colorWithHexString:@"333333"]colorWithAlphaComponent:1];
    }
    return YES;
}

-(void) textViewDidChange:(UITextView *)textView
{
    if([textView isEqual:titleTextView] && titleTextView.text.length == 0){
        titleTextView.text = @"ADD GOAL";
        [titleTextView resignFirstResponder];
    }else if(![textView isEqual:titleTextView] && questiontextDetailsView.hidden){
        AddGoalQuestion *addGoalQuestion = (AddGoalQuestion *)[textView viewWithTag:textView.tag].superview;
//        if (textView.contentSize.height >= 50) {
//            addGoalQuestion.answerTextViewHeight.constant = textView.contentSize.height;
//        } else {
//            addGoalQuestion.answerTextViewHeight.constant = 50;
//        }
        addGoalQuestion.answerTextViewHeight.constant = 50;
        NSArray *subviews = [mainStackView subviews];
        for (int i=0; i<subviews.count; i++) {
            if ([addGoalQuestion isKindOfClass:[AddGoalQuestion class]]) {
                if (addGoalQuestion.answerTextView.text.length == 0) {
                    addGoalQuestion.answerTextView.textColor = [[Utility colorWithHexString:@"333333"]colorWithAlphaComponent:0.5];
                    addGoalQuestion.answerTextView.text = detailsPlaceholderArr[(textView.tag-1)-1000];
                }
            }
        }
    }
}

//chayan 23/10/2017
#pragma mark progressbar delegate

- (void) completedWithResponse:(NSString *)responseString responseDict:(NSDictionary *)responseDict{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"SuccessFlag"] boolValue]) {
            //gami_badge_popup
            if (self->_setNewGoal) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateBadgePoint" object:self];//gami_badge_popup
            }//gami_badge_popup

            if (self->reminderButton.selected && ![Utility isEmptyCheck:self->savedReminderDict] && [[self->savedReminderDict objectForKey:@"PushNotification"] boolValue]) {
                [self->resultDict setObject:[[responseDict objectForKey:@"Details"] objectForKey:@"id"] forKey:@"id"];
                NSMutableDictionary *extraData = [[NSMutableDictionary alloc] init];
                [extraData setObject:self->resultDict forKey:@"selectedGoalDict"];
                [extraData setObject:self->_valuesArray forKey:@"valuesArray"];
                [SetReminderViewController setOldLocalNotificationFromDictionary:self->savedReminderDict ExtraData:extraData FromController:(NSString *)@"Goal" Title:self->titleTextView.text Type:@"Goal" Id:[[self->_selectedGoalDict objectForKey:@"id"] intValue]];
            }
            [self.navigationController popViewControllerAnimated:YES];
//            [self dismissViewControllerAnimated:YES completion:nil];
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



#pragma Mark - End

#pragma mark - Notes Delegate
-(void)saveButtonDetails:(NSString *)saveText with:(UITextView *)textview{
    [textview setContentOffset:CGPointZero animated:NO];
    [mainScroll setContentOffset:CGPointZero animated:NO];
    for (int i = 0; i < questionArray.count; i++) {
        UITextView *textView = (UITextView*)[self.view viewWithTag:i+1001];
        if ([textView isKindOfClass:[UITextView class]] && (textView.tag == quesTag)) {
            textView.accessibilityHint = saveText;
            textView.attributedText = [Utility converHtmltotext:saveText];
            textView.textColor = [[Utility colorWithHexString:@"333333"]colorWithAlphaComponent:1];
        }
    }
}
-(void)cancelNotes{
    [mainScroll setContentOffset:CGPointZero animated:NO];
}



@end
