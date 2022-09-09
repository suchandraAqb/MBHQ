//
//  VisionHomeViewController.m
//  Squad
//
//  Created by aqb-mac-mini3 on 02/11/18.
//  Copyright © 2018 AQB Solutions. All rights reserved.
//

#import "VisionHomeViewController.h"
#import "VisionCollectionViewCell.h"
#import "VisionGoalActionTableViewCell.h"
#import "AddVisionBoardViewController.h"
#import "DisplayImageViewController.h"

@interface VisionHomeViewController (){
    
    __weak IBOutlet UIButton *HeaderButton;
    __weak IBOutlet UIButton *boardButton;
    __weak IBOutlet UIButton *statementButton;
    __weak IBOutlet UIButton *addEditButton;
    __weak IBOutlet UIButton *alarmButton;
    __weak IBOutlet UIView *addVisionView;
    
  
    //    __weak IBOutlet UICollectionView *imageCollectionView;
    __weak IBOutlet UIImageView *visionImageView;
    __weak IBOutlet NSLayoutConstraint *visionImageViewHeightConstraint;
    __weak IBOutlet UITableView *statementTable;
    UIView *contentView;
    NSMutableDictionary *visionDict;
    BOOL isEdit;
    int editRow;
    __weak IBOutlet UIView *mainView;
//    __weak IBOutlet UIView *visionAddView;
    
    IBOutlet UIButton *notificationButton;
    
    NSMutableArray *statementList;
    UITextView *activeTextView;
    UIToolbar *numberToolbar;
    __weak IBOutlet UIView *saveView;
    BOOL isFirstTimeReminderSet;
    __weak IBOutlet UIView *addEditView;
    __weak IBOutlet UIButton *addPhotoButton;
    __weak IBOutlet UIButton *editPhotoButton;
   
    
    IBOutlet UIButton *saveButton;
    
}

@end

@implementation VisionHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    isFirstTimeReminderSet = true;
    visionImageView.hidden = true;
   // statementTable.hidden = true;
    boardButton.selected = true;
    //addEditView.hidden = true;
    statementButton.selected = false;
   // alarmButton.hidden = true;
    visionDict = [NSMutableDictionary new];
    statementList = [NSMutableArray new];
    //isEdit = false;
    //editRow = -1;
    addVisionView.hidden = false;
//    alarmButton.layer.borderWidth = 1;
//    alarmButton.layer.borderColor = squadMainColor.CGColor;
    
    [mainView setNeedsLayout];
    [mainView layoutIfNeeded];
    mainView.layer.cornerRadius = 25.0;
    mainView.layer.masksToBounds = YES;
    //addEditButton.layer.borderColor = squadMainColor.CGColor;
    //addEditButton.layer.borderWidth = 1;
    addPhotoButton.layer.borderColor = squadMainColor.CGColor;
    addPhotoButton.layer.borderWidth = 1;
    editPhotoButton.layer.borderColor = squadMainColor.CGColor;
    editPhotoButton.layer.borderWidth = 1;
    
    numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone  target:self action:@selector(doneWithFirstResponder)],nil];
    [numberToolbar sizeToFit];
    [self registerForKeyboardNotifications];
    
   // NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:@"My "];
   // [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"EyeCatchingPro" size:35] range:NSMakeRange(0, [attributedString length])];
   // [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, [attributedString length])];
    
 //   NSMutableAttributedString *attributedString2 =[[NSMutableAttributedString alloc]initWithString:@"VISION BOARD"];
   // [attributedString2 addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Oswald-Light" size:17] range:NSMakeRange(0, [attributedString2 length])];
  //  [attributedString2 addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, [attributedString2 length])];
    
  //  [attributedString appendAttributedString:attributedString2];
 //   [HeaderButton setAttributedTitle:attributedString forState:UIControlStateNormal];
    self->saveView.hidden = true;
    //[alarmButton setImage:[UIImage imageNamed:@"clockPersonal.png"] forState:UIControlStateNormal];
    //[alarmButton setImage:[UIImage imageNamed:@"clockPersonal_green.png"] forState:UIControlStateSelected];
   // if ([Utility isEmptyCheck:[defaults objectForKey:@"isFirstTimeVision"]]) {
       // [Utility showHelpAlertWithURL:@"https://player.vimeo.com/external/125750379.m3u8?s=c85a3928071e47c744698cf66662e8543adcf3f8" controller:self haveToPop:NO];
     //   [defaults setObject:[NSNumber numberWithBool:false] forKey:@"isFirstTimeVision"];
   // }
  //  visionImageView.userInteractionEnabled = true;/
  //  UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(tapAction:)];
   // tapGesture.numberOfTapsRequired = 1;
   // [visionImageView addGestureRecognizer:tapGesture];
    
    #pragma mark - Save Button corner change
    
    saveButton.layer.borderColor = [UIColor colorWithRed:20.0 / 255.0 green:227.0 / 255.0 blue:209.0 / 255.0 alpha:1.0].CGColor;
    
    saveButton.clipsToBounds = YES;
    saveButton.layer.borderWidth = 1.2;
    saveButton.layer.cornerRadius = 18;
    
    [self toggleBoardStatementPressed:statementButton];
    [self addEditButtonPressed:statementButton];
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

   // [self getDataWithApi:@"GetVisionBoardAPI"];
    [self goalVisionBoardStatementList];
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
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
#pragma mark - End
#pragma mark - IBAction

- (void)doneWithFirstResponder{
    [self.view endEditing:YES];
}
- (IBAction)toggleBoardStatementPressed:(UIButton *)sender {
    if (sender.isSelected) {
        return;
    }
    if ([Utility isEmptyCheck:visionDict]) {
        addVisionView.hidden = false;
        [Utility msg:@"Please create vision board first." title:nil controller:self haveToPop:NO];
        return;
    }
    //isEdit = false;
    //editRow = -1;
   // saveView.hidden = true;
   // addEditView.hidden = true;
    addVisionView.hidden = true;
    if (sender == boardButton) {
        boardButton.selected = true;
        statementButton.selected = false;
        statementTable.hidden = true;
//        imageCollectionView.hidden = false;
        if (![Utility isEmptyCheck:[self->visionDict objectForKey:@"GoalVisionBoardImagesModelList"]]) {
            [self->addEditButton setImage:[UIImage imageNamed:@"edit_inactive.png"] forState:UIControlStateNormal];
            [self->addEditButton setTitle:@"EDIT VISION BOARD" forState:UIControlStateNormal];
            [self->addEditButton setTitleColor:squadMainColor forState:UIControlStateNormal];
            [self->addEditButton setBackgroundColor:[UIColor whiteColor]];
            visionImageView.hidden = false;
        }else{
            [self->addEditButton setImage:[UIImage imageNamed:@"plus_setprogram.png"] forState:UIControlStateNormal];
            [self->addEditButton setTitle:@"UPLOAD VISION BOARD PHOTOS" forState:UIControlStateNormal];
            [self->addEditButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self->addEditButton setBackgroundColor:squadMainColor];
            visionImageView.hidden = true;
        }
//        [imageCollectionView reloadData];
    } else {
        boardButton.selected = false;
        statementButton.selected = true;
        statementTable.hidden = false;
        if (![Utility isEmptyCheck:statementList]) {
            [self->addEditButton setImage:[UIImage imageNamed:@"edit_inactive.png"] forState:UIControlStateNormal];
            [self->addEditButton setTitle:@"EDIT VISION STATEMENT" forState:UIControlStateNormal];
            [self->addEditButton setTitleColor:squadMainColor forState:UIControlStateNormal];
            [self->addEditButton setBackgroundColor:[UIColor whiteColor]];
        }
        [statementTable reloadData];
//        imageCollectionView.hidden = true;
        visionImageView.hidden = true;
    }
}
- (IBAction)addEditButtonPressed:(UIButton *)sender {
    //top add edit button
    if (boardButton.isSelected) {
        [self uploadPhotoPressed:nil];
//        if ([Utility isEmptyCheck:[visionDict objectForKey:@"GoalVisionBoardImagesModelList"]]) {
//            //add vision board
//            visionAddView.hidden = false;
//
//        }else{
//            //edit vision board
//            addEditView.hidden = !addEditView.isHidden;
//            if(!addEditView.isHidden){
//                isEdit = false;
//                [imageCollectionView reloadData];
//            }
//            NSArray *arr = [visionDict objectForKey:@"GoalVisionBoardImagesModelList"];
//            if(arr.count < 10){
//                addPhotoButton.alpha = 1.0;
//                addPhotoButton.enabled = true;
//            }else{
//                addPhotoButton.alpha = 0.5;
//                addPhotoButton.enabled = false;
//            }
//        }
    } else {
        isEdit = !isEdit;
        if (isEdit) {
            
        }else{
            editRow = -1;
        }
        [statementTable reloadData];
    }
    [self.view layoutIfNeeded];
}
- (IBAction)alarmButtonPressed:(UIButton *)sender {
    if (![sender isSelected]) {
        SetReminderViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SetReminder"];
        if ([visionDict objectForKey:@"FrequencyId"] != nil)
            controller.defaultSettingsDict = visionDict;
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
                                       if ([self->visionDict objectForKey:@"FrequencyId"] != nil)
                                           controller.defaultSettingsDict = self->visionDict;
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
                                      //                                      self->isChanged = YES;
                                      self->alarmButton.selected = false;
                                      NSArray *requests = [[UIApplication sharedApplication] scheduledLocalNotifications];
                                      for (UILocalNotification *req in requests) {
                                          NSString *pushTo = [req.userInfo objectForKey:@"pushTo"];
                                          if ([pushTo caseInsensitiveCompare:@"Vision"] == NSOrderedSame) {
                                              [[UIApplication sharedApplication] cancelLocalNotification:req];
                                          }
                                      }
                                      [self->visionDict removeObjectForKey:@"FrequencyId"];
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

- (IBAction)cancelPressed:(UIButton *)sender {
//    visionAddView.hidden = true;
}
- (IBAction)uploadPhotoPressed:(UIButton *)sender {
//    NSArray *imgArray = [visionDict objectForKey:@"GoalVisionBoardImagesModelList"];
//    if (![Utility isEmptyCheck:imgArray]) {
//        if (imgArray.count>=10) {
//            return;
//        }
//    }
    AddVisionBoardViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AddVisionBoard"];
    if (![Utility isEmptyCheck:visionDict]) {
        controller.visionBoardDict = visionDict;
    }
//    if(sender.tag == 1){
        controller.picMaxLimit = 1;
//    }else{
////        NSArray *imgArray = [visionDict objectForKey:@"GoalVisionBoardImagesModelList"];
//        NSInteger count = 0;
//        if (![Utility isEmptyCheck:imgArray]) {
//            count = imgArray.count;
//        }
//        controller.picMaxLimit = 10 - count;
//    }
//    visionAddView.hidden = true;
    [self.navigationController pushViewController:controller animated:YES];
}
- (IBAction)saveButtonPressed:(UIButton *)sender {
   // [self updateVisionBoardStatement];
}

- (IBAction)pencilEditPhotoPressed:(UIButton *)sender {
    //hidden edit button
    addVisionView.hidden = !addVisionView.isHidden;
    [self.view layoutIfNeeded];
}
#pragma mark - End
#pragma mark - Private Method
-(void)prepareView{
    if (![Utility isEmptyCheck:self->visionDict]) {
       // addVisionView.hidden = true;
        if (![Utility isEmptyCheck:[self->visionDict objectForKey:@"GoalVisionBoardImagesModelList"]]) {
            //            self->imageCollectionView.hidden = false;
            //            [self->imageCollectionView reloadData];
            visionImageView.hidden = false;
            NSArray *imageArray = [visionDict objectForKey:@"GoalVisionBoardImagesModelList"];
            NSDictionary *imgDict;
            if (![Utility isEmptyCheck:imageArray]) {
                imgDict = [imageArray objectAtIndex:imageArray.count-1];
            } else {
                imgDict = [NSDictionary new];
            }
            [visionImageView sd_setImageWithURL:[NSURL URLWithString:[imgDict objectForKey:@"BoardImage"]] placeholderImage:[UIImage imageNamed:@"upload_image.png"] options:SDWebImageScaleDownLargeImages completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if (image) {
                    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
                    CGFloat imageViewHeight = image.size.height/image.size.width * screenWidth;
                    //                NSLog(@"ih %f iw %f",image.size.height,image.size.width);
                    if (imageViewHeight > 0) {
                        self->visionImageViewHeightConstraint.constant = imageViewHeight;
                    }
                }
                
            }];
            self->statementTable.hidden = true;
            //[self->addEditButton setImage:[UIImage imageNamed:@"edit_inactive.png"] forState:UIControlStateNormal];
           // [self->addEditButton setTitle:@"EDIT VISION BOARD" forState:UIControlStateNormal];
           // [self->addEditButton setTitleColor:squadMainColor forState:UIControlStateNormal];
            //[self->addEditButton setBackgroundColor:[UIColor whiteColor]];
        }else{
//            self->imageCollectionView.hidden = true;
            visionImageView.hidden = true;
           // [self->addEditButton setImage:[UIImage imageNamed:@"plus_setprogram.png"] forState:UIControlStateNormal];
           // [self->addEditButton setTitle:@"UPLOAD VISION BOARD PHOTOS" forState:UIControlStateNormal];
            //[self->addEditButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            //[self->addEditButton setBackgroundColor:squadMainColor];
        }
        /*
        if (![Utility isEmptyCheck:[self->visionDict objectForKey:@"PushNotification"]] && ![Utility isEmptyCheck:[self->visionDict objectForKey:@"Email"]] && ([[self->visionDict objectForKey:@"PushNotification"] boolValue] || [[self->visionDict objectForKey:@"Email"] boolValue])) {
           // self->alarmButton.selected = true;
            self->notificationButton.selected = true;
        } else {
            //self->alarmButton.selected = false;
            self->notificationButton.selected = false;
        }
        if (self->alarmButton.isSelected) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateBadgePoint" object:self];//gami_badge_popup
            
            NSArray *requests = [[UIApplication sharedApplication] scheduledLocalNotifications];
            for (UILocalNotification *req in requests) {
                NSString *pushTo = [req.userInfo objectForKey:@"pushTo"];
                if ([pushTo caseInsensitiveCompare:@"Vision"] == NSOrderedSame) {
                    [[UIApplication sharedApplication] cancelLocalNotification:req];
                }
            }
            if ([[self->visionDict objectForKey:@"PushNotification"] boolValue])
                [SetReminderViewController setOldLocalNotificationFromDictionary:self->visionDict ExtraData:[NSMutableDictionary new] FromController:@"Vision" Title:@"Ashy Bines Squad" Type:@"Vision" Id:0];
        }
        alarmButton.hidden = false;
    }else{
        alarmButton.hidden = true;
    }*/
    //Ru
    if (self->notificationButton.isSelected) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateBadgePoint" object:self];//gami_badge_popup
        
        NSArray *requests = [[UIApplication sharedApplication] scheduledLocalNotifications];
        for (UILocalNotification *req in requests) {
            NSString *pushTo = [req.userInfo objectForKey:@"pushTo"];
            if ([pushTo caseInsensitiveCompare:@"Vision"] == NSOrderedSame) {
                [[UIApplication sharedApplication] cancelLocalNotification:req];
            }
        }
        if ([[self->visionDict objectForKey:@"PushNotification"] boolValue])
            [SetReminderViewController setOldLocalNotificationFromDictionary:self->visionDict ExtraData:[NSMutableDictionary new] FromController:@"Vision" Title:@"MBHQ" Type:@"Vision" Id:0];
    }
    notificationButton.hidden = false;
}else{
    notificationButton.hidden = true;
}
    
}
#pragma mark - End
#pragma mark -APICall
-(void)getDataWithApi:(NSString *)apiName {
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
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:apiName append:@"" forAction:@"POST"];
        
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
                                                                           self->visionDict = [[responseDictionary objectForKey:@"Details"]mutableCopy];
                                                                           [self prepareView];
                                                                           //                                                                           NSDictionary *visionDict = [responseDictionary objectForKey:@"Details"];
                                                                           //                                                                           self->visionMutableDict = [visionDict mutableCopy];  //ah ln1
                                                                           //                                                                           [self setUpVisionBoardFromDict:visionDict];
                                                                           //
                                                                           //                                                                           if (self->shouldSetupRem) {
                                                                           //                                                                               [self setUpReminderFor:@"Vision"];    //ah ln1
                                                                           //                                                                           }
                                                                       } else {
//                                                                           [Utility msg:[responseDictionary objectForKey:@"ErrorMessage"] title:@"Error !" controller:self haveToPop:NO];
                                                                       }
                                                                   }else{
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
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GoalVisionBoardStatementList" append:@"" forAction:@"POST"];
        
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
                                                                           
                                                                           self->statementList = [[responseDictionary objectForKey:@"List"]mutableCopy];
                                                                           [self->statementTable reloadData];
                                                                           
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
        [mainDict setObject:statementList forKey:@"VisionBoardStatementList"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"UpdateVisionBoardStatement" append:@"" forAction:@"POST"];
        
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
                                                                           self->isEdit = false;
                                                                           self->editRow = -1;
                                                                           self->saveView.hidden = true;
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

-(void) saveDataWithMultipart {
    if (Utility.reachable) {
        NSMutableDictionary *resultDict = [visionDict mutableCopy];
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
        NSString *html = @"";//visionText;
        NSLog(@"html: %@",html);
        if (![Utility isEmptyCheck:html]) {
            [resultDict setObject:html forKey:@"OnThisDateIwillLook"];
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
//        for (int i=0; i<imageArray.count; i++) {
//            NSDictionary *dict = [imageArray objectAtIndex:i];
//            if ([[dict objectForKey:@"isLocal"]boolValue]) {
//                UIImage *img = [dict objectForKey:@"image"];
//                [imgDict setObject:img forKey:[@"image" stringByAppendingFormat:@"%d",i]];
//            }
//        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        ProgressBarViewController *controller=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ProgressBar"];
        controller.delegate=self;
        controller.apiName=@"AddUpdateVisionBoardWithPhoto";
        controller.isMultiImage=YES;
        controller.appendString=@"";
        controller.jsonString=jsonString;
        controller.imageDataDict=imgDict;//[NSDictionary dictionaryWithObjectsAndKeys:UIImagePNGRepresentation(chosenImage),@"image0", nil];
        //        controller.chosenImage=chosenImage;
        controller.modalPresentationStyle = UIModalPresentationCustom;
        [self presentViewController:controller animated:YES completion:nil];
    }
    else{
        [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
    }
    
}

#pragma mark - End
#pragma mark - CollectionView DataSource & Delegate
/*not in use*/
- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//    NSArray *imageArray = [visionDict objectForKey:@"GoalVisionBoardImagesModelList"];
    return 0;//imageArray.count;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
//    NSArray *imageArray = [visionDict objectForKey:@"GoalVisionBoardImagesModelList"];
    CGFloat width = 0;
    CGFloat height = 0;
//    if (imageArray.count == 1) {
//        width = imageCollectionView.frame.size.width - 16;
//        height = width;
//    } else {
//        width = (imageCollectionView.frame.size.width - 10)/2;
//        height = (width * 1.2);
//    }
    return CGSizeMake(width, height);
}
- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    VisionCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"VisionCollectionViewCell" forIndexPath:indexPath];
    
    NSArray *imageArray = [visionDict objectForKey:@"GoalVisionBoardImagesModelList"];
    if (![Utility isEmptyCheck:imageArray]) {
        NSDictionary *imgDict = [imageArray objectAtIndex:indexPath.row];
        [cell.visionImage sd_setImageWithURL:[NSURL URLWithString:[imgDict objectForKey:@"BoardImage"]] placeholderImage:[UIImage imageNamed:@"upload_image.png"] options:SDWebImageScaleDownLargeImages];
//        cell.visionImage.layer.borderColor = squadMainColor.CGColor;
//        cell.visionImage.layer.borderWidth = 1;
        cell.deleteButton.hidden = !isEdit;
        cell.deleteButton.tag = [[imgDict objectForKey:@"GoalVisionBoardImgId"]intValue];
        
    }
    
    return cell;
}
#pragma mark - End

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
            cell.statementLabel.text = [@"" stringByAppendingFormat:@"%@",![Utility isEmptyCheck:[dict objectForKey:@"statement"]]?[@"" stringByAppendingFormat:@"%@:",[dict objectForKey:@"statement"]]:@""];
            cell.statementTextView.text = [@"" stringByAppendingFormat:@"%@",![Utility isEmptyCheck:[dict objectForKey:@"Answer"]]?[dict objectForKey:@"Answer"]:@""];
//            [cell setNeedsLayout];
//            [cell layoutIfNeeded];
//            [cell.statementTextView setNeedsLayout];
//            [cell.statementTextView layoutIfNeeded];
                [cell.statementTextView setScrollEnabled:NO];
            

//            if (cell.statementTextView.contentSize.height>61) {
//                cell.statementTextViewHeightConstraint.constant = cell.statementTextView.contentSize.height;
//            } else {
//                cell.statementTextViewHeightConstraint.constant = 61;
//            }
            
           // cell.editView.hidden = !isEdit;
            cell.statementTextView.inputAccessoryView = numberToolbar;
//            if (editRow == indexPath.row) {
//                cell.editView.hidden = true;
//            }
            cell.statementTextView.layer.borderWidth = 1;
            cell.statementTextView.layer.borderColor = squadSubColor.CGColor;
            cell.statementTextView.tag = indexPath.row;
           // cell.editButton.tag = indexPath.row;
           // [cell.editButton addTarget:self action:@selector(editStatementPressed:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (![Utility isEmptyCheck:visionDict]) {
        return 45.0;
    }
    return 0.0;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(tableView.frame.origin.x, tableView.frame.origin.y, tableView.frame.size.width, 45.0)];
    headerView.backgroundColor = [UIColor whiteColor];
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(5, 5, headerView.frame.size.width - 10, 35.0)];
    NSDateFormatter *df = [NSDateFormatter new];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSString *txt=@"";
    if (![Utility isEmptyCheck:visionDict]) {
        txt = [visionDict objectForKey:@"VisionDate"];
        txt = [df stringFromDate:[df dateFromString:[Utility getDateOnly:txt]]];
    }
    NSDate *date = [df dateFromString:txt];
    [df setDateFormat:@"dd MMM yyyy"];
    txt = [@"" stringByAppendingFormat:@"ON THE %@ :",[df stringFromDate:date]];
    [button setTitle:txt forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont fontWithName:@"Raleway" size:17.0];
    [button setTitleColor:squadMainColor forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor whiteColor]];
    //[button.layer setBorderWidth:1.0];
    //[button.layer setBorderColor:squadMainColor.CGColor];
    [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [button setContentEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 10)];
    [button addTarget:self action:@selector(visionDateButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    [headerView addSubview:button];
    return headerView;
}
- (IBAction)visionDateButtonTapped:(id)sender {
    DatePickerViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DatePicker"];
    controller.modalPresentationStyle = UIModalPresentationCustom;
    
    NSString *txt=@"";
    NSDateFormatter *df = [NSDateFormatter new];
    [df setDateFormat:@"yyyy-MM-dd"];
    if (![Utility isEmptyCheck:visionDict]) {
        txt = [visionDict objectForKey:@"VisionDate"];
    }
    
    controller.selectedDate = [df dateFromString:[Utility getDateOnly:txt]];
    controller.datePickerMode = UIDatePickerModeDate;
    controller.delegate = self;
    [self presentViewController:controller animated:YES completion:nil];
}
#pragma mark - End
#pragma  mark - DatePickerViewControllerDelegate

-(void)didSelectDate:(NSDate *)date{
    
    if (date) {
        static NSDateFormatter *dateFormatter;
        dateFormatter = [NSDateFormatter new];
        
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
        NSString *currentDateStr = [dateFormatter stringFromDate:date];
        [visionDict setObject:currentDateStr forKey:@"VisionDate"];
        [statementTable reloadData];
        [self saveDataWithMultipart];
    }
}
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
    CGFloat hit = 0;
    if (saveView.isHidden) {
        hit = 45;
    }
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height-155+hit, 0.0);
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
#pragma mark - textView Delegate
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    BOOL shouldStart = false;
    if (editRow == textView.tag) {
        shouldStart = true;
    }
    return shouldStart;
}
- (void)textViewDidBeginEditing:(UITextView *)textView{
    activeTextView=textView;
    [textView setScrollEnabled:YES];
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    activeTextView=nil;
    NSMutableDictionary *dict = [[statementList objectAtIndex:textView.tag]mutableCopy];
    [dict setObject:textView.text forKey:@"Answer"];
    [statementList replaceObjectAtIndex:textView.tag withObject:dict];
    if (textView.text.length>0) {
        saveView.hidden = false;
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
    
    
    //[self->statementTable reloadData];
    [textView resignFirstResponder];
    
}
- (BOOL)textView:(UITextView *)txtView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
//    VisionGoalActionTableViewCell *vCell;
//    NSIndexPath *mIndex = 0;
//    @try {
//        mIndex = [NSIndexPath indexPathForRow:editRow inSection:0];
//        vCell = (VisionGoalActionTableViewCell *)[statementTable cellForRowAtIndexPath:mIndex];
//    } @catch (NSException *exception) {
//
//    }
//    if (!vCell) {
//        vCell = [[VisionGoalActionTableViewCell alloc]init];
//    }
//    NSArray* rowsToReload = [NSArray arrayWithObjects:mIndex, nil];
//    NSMutableDictionary *dict = [[statementList objectAtIndex:txtView.tag]mutableCopy];
//    [dict setObject:txtView.text forKey:@"Answer"];
//    [statementList replaceObjectAtIndex:txtView.tag withObject:dict];
//    vCell.statementTextView.text = txtView.text;
//    vCell.statementTextViewHeightConstraint.constant = txtView.contentSize.height>61?txtView.contentSize.height:61;
//    [statementTable reloadRowsAtIndexPaths:rowsToReload withRowAnimation:UITableViewRowAnimationNone];
    //[self.view layoutIfNeeded];
    
    //txtView.translatesAutoresizingMaskIntoConstraints = true;
    //[txtView sizeToFit];
    return YES;
}
-(void)textViewDidChange:(UITextView *)textView{
//    VisionGoalActionTableViewCell *vCell;
//    NSIndexPath *mIndex = 0;
//    @try {
//        mIndex = [NSIndexPath indexPathForRow:editRow inSection:0];
//        vCell = (VisionGoalActionTableViewCell *)[statementTable cellForRowAtIndexPath:mIndex];
//    } @catch (NSException *exception) {
//
//    }
//    if (!vCell) {
//        vCell = [[VisionGoalActionTableViewCell alloc]init];
//    }
//    NSArray* rowsToReload = [NSArray arrayWithObjects:mIndex, nil];
//    NSMutableDictionary *dict = [[statementList objectAtIndex:textView.tag]mutableCopy];
//    [dict setObject:textView.text forKey:@"Answer"];
//    [statementList replaceObjectAtIndex:textView.tag withObject:dict];
//    vCell.statementTextView.text = textView.text;
//    vCell.statementTextViewHeightConstraint.constant = textView.contentSize.height>61?textView.contentSize.height:61;
//    [statementTable reloadRowsAtIndexPaths:rowsToReload withRowAnimation:UITableViewRowAnimationAutomatic];
}
#pragma mark - ReminderDelegate
-(void) reminderSettingsValue:(NSMutableDictionary *)reminderDict {
    NSLog(@"rem %@",reminderDict);
    //    isChanged = YES;
    //    savedReminderDict = reminderDict;   //ah ln1
    [self->visionDict addEntriesFromDictionary:reminderDict];
    
   // self->alarmButton.selected = true;
     self->notificationButton.selected = true;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateBadgePoint" object:self];//gami_badge_popup
    
    NSArray *requests = [[UIApplication sharedApplication] scheduledLocalNotifications];
    for (UILocalNotification *req in requests) {
        NSString *pushTo = [req.userInfo objectForKey:@"pushTo"];
        if ([pushTo caseInsensitiveCompare:@"Vision"] == NSOrderedSame) {
            [[UIApplication sharedApplication] cancelLocalNotification:req];
        }
    }
    if ([[self->visionDict objectForKey:@"PushNotification"] boolValue])
        [SetReminderViewController setOldLocalNotificationFromDictionary:self->visionDict ExtraData:[NSMutableDictionary new] FromController:@"Vision" Title:@"MBHQ" Type:@"Vision" Id:0];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self saveDataWithMultipart];
    });
}
-(void) cancelReminder {
//    if ([resultDict objectForKey:@"FrequencyId"] != nil) {
//
//    } else {
//        [setReminderSwitch setOn:NO];
//        [resultDict removeObjectForKey:@"FrequencyId"];
//    }
//    [self prepareReminderView];
}
#pragma mark progressbar delegate

- (void) completedWithResponse:(NSString *)responseString responseDict:(NSDictionary *)responseDict{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"SuccessFlag"] boolValue]) {
            
            [self dismissViewControllerAnimated:YES completion:nil];
//            [self getDataWithApi:@"GetVisionBoardAPI"];
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
