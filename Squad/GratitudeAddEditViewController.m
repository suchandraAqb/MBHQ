
//  GratitudeAddEditViewController.m
//  Squad
//
//  Created by AQB Solutions-Mac Mini 2 on 14/03/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//


#import "GratitudeAddEditViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "SongPlayListViewController.h"

#import <AVKit/AVKit.h> //song19
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "GratitudePopUpViewController.h"

@interface GratitudeAddEditViewController (){
    IBOutlet UIScrollView *mainScroll;
    IBOutlet UIButton *viewReminder;
    IBOutlet UIButton *copyButton;
    IBOutlet UIButton *editButton;
    IBOutlet UIView *editCopyContainerViewEdit;
    IBOutlet UIButton *saveButton;
    IBOutlet UIButton *doneButton;
    IBOutlet UIButton *cancelButton;
    IBOutlet UIButton *deleteButton;
    IBOutlet UIView *saveCancelContainerView;
    
    IBOutlet UILabel *gratitude;
    IBOutlet UIImageView *gratudeImageView;
    IBOutlet UIView *setReminderContainerView;
    IBOutlet UIButton *deleteImageButton;
    IBOutlet UIButton *addEditImage;
    IBOutlet UIView *imageUploadDeleteContainer;
    
    IBOutlet UITextView *gratitudeDetails;
    IBOutlet UIView *dateView;
    IBOutlet UIButton *dateButton;
    
    IBOutlet UIView *gratefulView;
    
    IBOutlet UITextView *gratitudeTitle;
    IBOutlet UILabel *gratitudeDaySubTitle;
    
    IBOutlet NSLayoutConstraint *imageViewHeightConstraint;   //ah 22.3
    
    IBOutlet UISwitch *reminderSwitch;
    IBOutlet UIButton *selectSongButton;//song19
    IBOutlet UIView *songView;//song19
    IBOutlet UIButton *gratitudeShareButton;
    IBOutlet UIView *showPicTypeView;
    IBOutlet UIView *seeExampleView;
    IBOutlet UIImageView *seeExampleImage;
    IBOutletCollection(UIButton) NSArray *buttonArr;
    UIView *contentView;
    UITextField *activeTextField;
    UITextView *activeTextView;
    UIToolbar *toolBar;
    UIImage *selectedImage;
    BOOL isCopy;
    AVAudioPlayer *player;//song19
    BOOL isFirstTime;//song19
    
    NSMutableDictionary *savedReminderDict;     //ah ln1
    BOOL isChanged;
    BOOL isFirstTimeReminderSet; //gami_badge_popup
    BOOL isLoad;
    BOOL isReminderSet;
    NSString *localImageName;
    NSString *prvlocalImageName;
    BOOL isExistingImageChange;
    BOOL isTitleSave;
    BOOL statusOfReminder;
    BOOL isTrueShare;
    NSDictionary *shareDict;
    NSDate *selectedDate;
}

@end

@implementation GratitudeAddEditViewController
@synthesize isEdit,gratitudeData,gratitudeDelegate;


#pragma mark - UIImagePickerControllerDelegate methods

/*
 Open PECropViewController automattically when image selected.
 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    isChanged=YES;
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    image =[Utility scaleImage:image width:image.size.width height:image.size.height];
    gratudeImageView.image = image;
    selectedImage=image;
    isExistingImageChange = true;
    //Ru
    // [addEditImage setTitle:@"Change Image" forState:UIControlStateNormal];
    deleteImageButton.hidden = false;
    [picker dismissViewControllerAnimated:YES completion:^{
        [self openEditor:nil];
    }];
}
#pragma mark - End
#pragma mark - PECropViewControllerDelegate methods

- (void)cropViewController:(PECropViewController *)controller didFinishCroppingImage:(UIImage *)croppedImage transform:(CGAffineTransform)transform cropRect:(CGRect)cropRect
{
    [controller dismissViewControllerAnimated:YES completion:^{
        self->isChanged = YES;
        [Utility startFlashingbutton:self->saveButton];
        [Utility startFlashingbutton:self->doneButton];
    }];
    //    userImageView.image = croppedImage;
    //    UIImage *image=[self scaleImage:croppedImage];
    gratudeImageView.image = croppedImage;
    selectedImage = croppedImage;
    isExistingImageChange = true;
    //Ru
    //[addEditImage setTitle:@"Change Image" forState:UIControlStateNormal];
    
    deleteImageButton.hidden = false;
    
    if(![Utility isEmptyCheck:localImageName]){
        prvlocalImageName = localImageName;
        localImageName = [Utility createImageFileNameFromTimeStamp];
    }else{
        localImageName = [Utility createImageFileNameFromTimeStamp];
    }
    
    [Utility writeImageInDocumentsDirectory:selectedImage imageName:localImageName];
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
    
    if(![Utility isEmptyCheck:localImageName]){
        prvlocalImageName = localImageName;
        localImageName = [Utility createImageFileNameFromTimeStamp];
    }else{
        localImageName = [Utility createImageFileNameFromTimeStamp];
    }
    
    [Utility writeImageInDocumentsDirectory:selectedImage imageName:localImageName];
    
    [controller dismissViewControllerAnimated:YES completion:^{
        self->isChanged = YES;
        [Utility startFlashingbutton:self->saveButton];
        [Utility startFlashingbutton:self->doneButton];
    }];
}


#pragma mark - PrivateMethod
-(void)getGratitudeSelectApiCall{
    if (Utility.reachable) {
        
        NSURLSession *achieveSession = [NSURLSession sharedSession];
        
        NSError *error;
        
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:[gratitudeData objectForKey:@"Id"] forKey:@"GratitudeId"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
            self->contentView = [Utility activityIndicatorView:self];
        });
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetGratitudeSelectApiCall" append:@"" forAction:@"POST"];
        
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
                                                                           self->gratitudeData = [[responseDictionary objectForKey:@"Details"] mutableCopy];
                                                                           if (![Utility isEmptyCheck:self->gratitudeData]) {
                                                                               [self prepareView];
                                                                               [self editButonPressed:0];

                                                                               if (self->_isFromListReminder) {
                                                                                   if (![Utility isEmptyCheck:self->gratitudeData]){
                                                                                       self->reminderSwitch.on = true;
                                                                                       [self reminderSwitch:self->reminderSwitch];
                                                                                      }
                                                                                  }
                                                                           }
                                                                           //Ru
                                                                           self->isLoad = true;
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

 -(void)delete{
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
         [mainDict setObject:AccessKey forKey:@"Key"];
         [mainDict setObject:[defaults valueForKey:@"UserSessionID"] forKey:@"UserSessionID"];
         [mainDict setObject:[gratitudeData valueForKey:@"Id"] forKey:@"GratitudeID"];
         
     
         NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
         if (error) {
         [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
         return;
         }
         NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
         NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"DeleteGratitudeApiCall" append:@"" forAction:@"POST"];
         NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
         dispatch_async(dispatch_get_main_queue(), ^{
             if (self->contentView) {
                 [self->contentView removeFromSuperview];
         }
             if(error == nil)
             {
             NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
             NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
             if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDictionary] && [[responseDictionary objectForKey:@"SuccessFlag"] boolValue]) {
                                         UIAlertController *alertController = [UIAlertController
                                         alertControllerWithTitle:@"Success"
                                         message:@"Gratitude Deleted Successfully. "
                                         preferredStyle:UIAlertControllerStyleAlert];
                                         UIAlertAction *okAction = [UIAlertAction
                                         actionWithTitle:@"OK"
                                         style:UIAlertActionStyleDefault
                                         handler:^(UIAlertAction *action) {
                                             if ([self->gratitudeDelegate respondsToSelector:@selector(didGratitudeBackAction:)]) {
                                                 [self->gratitudeDelegate didGratitudeBackAction:true];
                                             }
                                             [self.navigationController popViewControllerAnimated:YES];
                                             
                                         }];
                 [alertController addAction:okAction];
                 [self presentViewController:alertController animated:YES completion:nil];
         }else{
                 [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
                 return;
         }
 }else{
        [Utility msg:error.localizedDescription title:@"Error !" controller:self haveToPop:NO];
    }
 });
 
 
 }];
         [dataTask resume];
 }else{
     dispatch_async(dispatch_get_main_queue(), ^{
         [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
         return;
     });
    }
 }

-(void) saveData {
    if (Utility.reachable) {
        if (![Utility isEmptyCheck:gratitudeTitle.text] && gratitudeTitle.text.length > 0 && ![gratitudeTitle.text isEqualToString:@"Add Gratitude"]) {
            [gratitudeData setObject:gratitudeTitle.text forKey:@"Name"];
        }else{
            [Utility msg:@"Name is required " title:@"Error" controller:self haveToPop:NO];
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
            self->contentView = [Utility activityIndicatorView:self];
        });
        if (![Utility isEmptyCheck:gratitudeDetails.text]) {
            [gratitudeData setObject:gratitudeDetails.text forKey:@"Description"];
        }
        NSURLSession *achieveSession = [NSURLSession sharedSession];
        
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
        if (gratitudeData[@"Id"] == nil || isCopy) {
            [gratitudeData setObject:[NSNumber numberWithInteger:0] forKey:@"Id"];
        }
        if (gratitudeData[@"CreatedBy"] == nil) {
            [gratitudeData setObject:[defaults valueForKey:@"UserID"] forKey:@"CreatedBy"];
        }
        
        if (![Utility isEmptyCheck:selectedImage]) {
            NSString *imgBase64Str = [UIImagePNGRepresentation(selectedImage) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
            [gratitudeData setObject:imgBase64Str forKey:@"UploadPictureImgBase64"];
        }else{
            [gratitudeData setObject:@"" forKey:@"UploadPictureImgBase64"];
        }
        
        NSError *error;
        
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:gratitudeData forKey:@"model"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"AddUpdateGratitudeApiCall" append:@"" forAction:@"POST"];
        
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
                                                                           
                                                                           
                                                                           //ah ln1
                                                                           if (self->reminderSwitch.isOn && ![Utility isEmptyCheck:self->savedReminderDict] && [[self->savedReminderDict objectForKey:@"PushNotification"] boolValue]) {
                                                                               
                                                                               if ([Utility isEmptyCheck:self->gratitudeData]) {
                                                                                   self->gratitudeData = [[responseDictionary objectForKey:@"Details"] mutableCopy];
                                                                               } else {
                                                                                   [self->gratitudeData setObject:[[responseDictionary objectForKey:@"Details"] objectForKey:@"Id"] forKey:@"Id"];
                                                                               }
                                                                               
                                                                               //if (SYSTEM_VERSION_LESS_THAN(@"10")) {
                                                                               [SetReminderViewController setOldLocalNotificationFromDictionary:self->savedReminderDict ExtraData:self->gratitudeData FromController:@"Gratitude" Title:self->gratitudeTitle.text Type:@"Gratitude" Id:[[self->gratitudeData objectForKey:@"Id"] intValue]];
                                                                               
                                                                           }
                                                                           
                                                                           
                                                                           //                                                                           [Utility msg:@"Saved Successfully. " title:@"Success !" controller:self haveToPop:YES];
                                                                           
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
-(void) saveDataMultiPart {
    if (Utility.reachable) {
        if (![Utility isEmptyCheck:gratitudeTitle.text] && gratitudeTitle.text.length > 0 && ![gratitudeTitle.text isEqualToString:@"Add Gratitude"]) {
            [gratitudeData setObject:gratitudeTitle.text forKey:@"Name"];
        }else{
            [Utility msg:@"Name is required " title:@"Error" controller:self haveToPop:NO];
            return;
        }

        if (![Utility isEmptyCheck:gratitudeDetails.text]  && ![gratitudeDetails.text isEqualToString:@"Tap to start writing"]) {
                [gratitudeData setObject:gratitudeDetails.text forKey:@"Description"];
        }else{
                [gratitudeData setObject:@"" forKey:@"Description"];
        }
        
        if (![Utility isEmptyCheck:selectedDate]) {
            NSDateFormatter *dateFormatter = [NSDateFormatter new];
            [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
            [dateFormatter setDateFormat:@"yyyy-MM-dd'T'hh:mm:ss"];
            NSDate *dateFromCurrent = selectedDate;
            NSString *date = [dateFormatter stringFromDate:dateFromCurrent];
            [gratitudeData setObject:date forKey:@"CreatedAt"];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            NSString *datestring=[dateFormatter stringFromDate:dateFromCurrent];
            [gratitudeData setObject:datestring forKey:@"CreatedAtString"];
        }else{
            [Utility msg:@"Please select date." title:@"Warning !" controller:self haveToPop:NO];
            return;
        }
        
        
        
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
        if (gratitudeData[@"Id"] == nil || isCopy) {
            [gratitudeData setObject:[NSNumber numberWithInteger:0] forKey:@"Id"];
        }
        if (gratitudeData[@"CreatedBy"] == nil) {
            [gratitudeData setObject:[defaults valueForKey:@"UserID"] forKey:@"CreatedBy"];
        }
        
        if(![Utility isEmptyCheck:localImageName]){
            [gratitudeData setObject:localImageName forKey:@"PictureDevicePath"];
        }else{
            [gratitudeData setObject:@"" forKey:@"PictureDevicePath"];
        }
        
        
        
        
        
        
        [gratitudeData setObject:@"" forKey:@"UploadPictureImgBase64"];
        
        NSError *error;
        
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:gratitudeData forKey:@"model"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        ProgressBarViewController *controller=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ProgressBar"];
        controller.delegate=self;
        controller.apiName=@"AddUpdateGratitudeApiCallWithPhoto";
        controller.appendString=@"";
        controller.jsonString=jsonString;
        //controller.chosenImage=selectedImage;
        controller.chosenImage=nil;
        controller.modalPresentationStyle = UIModalPresentationCustom;
        [self presentViewController:controller animated:YES completion:nil];
    }else{
        [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
    }
    
}
- (IBAction)openEditor:(id)sender
{
    PECropViewController *controller = [[PECropViewController alloc] init];
    controller.delegate = self;
    controller.image = selectedImage;
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
-(void)prepareView{
    [self.view endEditing:YES];
    if (![Utility isEmptyCheck:gratitudeData]) {
        
        NSString *createdDate = [gratitudeData objectForKey:@"CreatedAt"];
        static NSDateFormatter *dateFormatter;
        dateFormatter = [NSDateFormatter new];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'hh:mm:ss"];
        NSDate *date = [dateFormatter dateFromString:createdDate];
        NSLog(@"%@",date);
        if (date) {
            selectedDate = date;
            [dateFormatter setDateFormat:@"MMM d yyyy"];
            NSString *dateString = [dateFormatter stringFromDate:date];
            [dateButton setTitle:dateString forState:UIControlStateNormal];
        }
        
        NSString *name = gratitudeData[@"Name"];
        gratitudeTitle.text = ![Utility isEmptyCheck:name] ? name : @"Add Gratitude";
        if (![gratitudeTitle.text isEqualToString:@"Add Gratitude"]) {
            gratitudeTitle.textColor = [Utility colorWithHexString:@"333333"];//squadMainColor;
        }else{
            gratitudeTitle.textColor = [UIColor lightGrayColor];
        }
        if (![Utility isEmptyCheck:[gratitudeData objectForKey:@"Description"]]) {
            
            NSMutableAttributedString *text1 = [[NSMutableAttributedString alloc] initWithString:[gratitudeData objectForKey:@"Description"]];
            NSArray *splitArr = [[gratitudeData objectForKey:@"Description"] componentsSeparatedByString:@":"];
            NSRange foundRange1 = [text1.mutableString rangeOfString:[splitArr objectAtIndex:0]];
            
            NSDictionary *attrDict1 = @{
                                        NSFontAttributeName : [UIFont fontWithName:@"Raleway-Medium" size:19.0],
                                        NSForegroundColorAttributeName : [Utility colorWithHexString:@"41515C"]
                                        
                                        };
            [text1 addAttributes:attrDict1 range:NSMakeRange(0, text1.length)];
            [text1 addAttributes:@{
                                   NSFontAttributeName : [UIFont fontWithName:@"Raleway-Bold" size:19.0]
                                   
                                   }
                           range:foundRange1];
            gratitudeDetails.attributedText = text1;
        }
//        gratitudeDetails.accessibilityHint = ![Utility isEmptyCheck:description]? description : @"";
        
        
        if(![Utility isEmptyCheck:[gratitudeData objectForKey:@"PictureDevicePath"]]){
            localImageName = [gratitudeData objectForKey:@"PictureDevicePath"];
            selectedImage = [Utility getImageFromDocumentDirectoryWithImageName:localImageName];
            
            if(selectedImage){
                CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
                CGFloat imageViewHeight = selectedImage.size.height/selectedImage.size.width * screenWidth;
                self->imageViewHeightConstraint.constant = imageViewHeight;
                gratudeImageView.image = selectedImage;
                [addEditImage setTitle:@"CHANGE IMAGE" forState:UIControlStateNormal];
            }else if (![Utility isEmptyCheck:[gratitudeData objectForKey:@"Picture"]]) {
                NSString *imageUrlString =[gratitudeData objectForKey:@"Picture"];
                                      [gratudeImageView sd_setImageWithURL:[NSURL URLWithString:[imageUrlString stringByAddingPercentEncodingWithAllowedCharacters:
                                                                                           [NSCharacterSet URLQueryAllowedCharacterSet]]]
                                                    placeholderImage:[UIImage imageNamed:@"img_holder.png"]
                                                           options:SDWebImageScaleDownLargeImages completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                                if (image) {
                                                                    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
                                                                    CGFloat imageViewHeight = image.size.height/image.size.width * screenWidth;
                                                                    self->imageViewHeightConstraint.constant = imageViewHeight;
                                                                    self->selectedImage = image;
                                                                    self->gratudeImageView.image = image;
                                                                    [self->addEditImage setTitle:@"CHANGE IMAGE" forState:UIControlStateNormal];
                                                                    }
                                                                else {
                                                                    self->selectedImage = nil;
                                                                    self->gratudeImageView.image = [UIImage imageNamed:@"upload_image.png"];
                                                                    [self->addEditImage setTitle:@"UPLOAD" forState:UIControlStateNormal];
                                                                }
                                                               });
                                                           }];
                
            }else{
                gratudeImageView.image = [UIImage imageNamed:@"upload_image.png"];
                [addEditImage setTitle:@"UPLOAD" forState:UIControlStateNormal];
            }
            
            
        }else if (![Utility isEmptyCheck:[gratitudeData objectForKey:@"Picture"]]) {
            NSString *imageUrlString =[gratitudeData objectForKey:@"Picture"];
                                  [gratudeImageView sd_setImageWithURL:[NSURL URLWithString:[imageUrlString stringByAddingPercentEncodingWithAllowedCharacters:
                                                                                       [NSCharacterSet URLQueryAllowedCharacterSet]]]
                                                placeholderImage:[UIImage imageNamed:@"img_holder.png"]
                                                       options:SDWebImageScaleDownLargeImages completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                                           dispatch_async(dispatch_get_main_queue(), ^{
                                                            if (image) {
                                                                CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
                                                                CGFloat imageViewHeight = image.size.height/image.size.width * screenWidth;
                                                                self->imageViewHeightConstraint.constant = imageViewHeight;
                                                                self->selectedImage = image;
                                                                self->gratudeImageView.image = image;
                                                                [self->addEditImage setTitle:@"CHANGE IMAGE" forState:UIControlStateNormal];
                                                                }
                                                            else {
                                                                self->selectedImage = nil;
                                                                self->gratudeImageView.image = [UIImage imageNamed:@"upload_image.png"];
                                                                [self->addEditImage setTitle:@"UPLOAD" forState:UIControlStateNormal];
                                                            }
                                                           });
                                                       }];
            
        }
        else{
            localImageName = [Utility createImageFileNameFromTimeStamp];
            gratudeImageView.image = [UIImage imageNamed:@"upload_image.png"];
            [addEditImage setTitle:@"UPLOAD" forState:UIControlStateNormal];
        }
        
        
        /*NSString *imageUrlString =[gratitudeData objectForKey:@"Picture"];
        if (![Utility isEmptyCheck:[gratitudeData objectForKey:@"Picture"]]) {
            imageUrlString = [imageUrlString stringByReplacingOccurrencesOfString:@"thumbnails/" withString:@""];
            NSURL *url = [NSURL URLWithString:imageUrlString];
            //[gratudeImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"EXERCISE-picture-coming.jpg"] options:SDWebImageRefreshCached];
            gratudeImageView.image = [UIImage imageNamed:@"EXERCISE-picture-coming.jpg"];
            SDWebImageManager *manager = [SDWebImageManager sharedManager];
            [manager loadImageWithURL:url
                              options:0
                             progress:^(NSInteger receivedSize, NSInteger expectedSize ,NSURL * targetURL) {
                                 // progression tracking code
                             }
                            completed:^(UIImage *image,NSData *data, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                if (image) {
                                    //ah 22.3
                                    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
                                    CGFloat imageViewHeight = image.size.height/image.size.width * screenWidth;
                                    self->imageViewHeightConstraint.constant = imageViewHeight;
                                    self->selectedImage = image;
                                    self->gratudeImageView.image = image;
                                    [self->addEditImage setTitle:@"CHANGE IMAGE" forState:UIControlStateNormal];
                                }
                                else {
                                    self->selectedImage = nil;
                                    self->gratudeImageView.image = [UIImage imageNamed:@"upload_image.png"];
                                    [self->addEditImage setTitle:@"UPLOAD" forState:UIControlStateNormal];
                                }
                            }];
        } else {
            gratudeImageView.image = [UIImage imageNamed:@"upload_image.png"];
            selectedImage = nil;
        }*/
        if ((![Utility isEmptyCheck:[gratitudeData objectForKey:@"PushNotification"]] && [[gratitudeData objectForKey:@"PushNotification"] boolValue]) || (![Utility isEmptyCheck:[gratitudeData objectForKey:@"Email"]] && [[gratitudeData objectForKey:@"Email"] boolValue])) {
            savedReminderDict = gratitudeData;   //ah ln1
            reminderSwitch.on = true;
        }else{
            reminderSwitch.on = false;
        }
    }
    if (!isEdit){
        if (![Utility isEmptyCheck:gratitudeData]) {
            deleteButton.hidden = false;
        }else{
            deleteButton.hidden = true;
        }
        editButton.hidden = false;
        saveCancelContainerView.hidden = true;
        doneButton.hidden = true;
        setReminderContainerView.hidden = true;
        copyButton.hidden = true;
        gratitudeTitle.editable = false;
        gratitudeDetails.editable = false;
        imageUploadDeleteContainer.hidden =true;
        //song19
        songView.hidden = YES;
        
        if (![Utility isEmptyCheck:[gratitudeData objectForKey:@"Song"]]) {
            //play song
            NSError *error;
            //            if ([[NSFileManager defaultManager] fileExistsAtPath:[_selectedGoalDict objectForKey:@"Song"]]) { @"%@*#*%@"
            NSArray *songArr = [[gratitudeData objectForKey:@"Song"] componentsSeparatedByString:@"*##*"];
            
            if (![Utility isEmptyCheck:songArr]) {
                if (songArr.count > 1) {
                    [selectSongButton setTitle:[songArr objectAtIndex:1] forState:UIControlStateNormal];
                }
                player = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL URLWithString:[songArr objectAtIndex:0]] error:&error];
                
                if (!error) {
                    [player prepareToPlay];
                    [player play];
                }
            }
            //}
        }
        //song19End
        
    }else{
        if (![Utility isEmptyCheck:gratitudeData]) {
            copyButton.hidden = false;
            editButton.hidden = true;
            deleteButton.hidden = false;
            
        }else{
            copyButton.hidden = true;
            editButton.hidden = true;
            deleteButton.hidden = true;
        }
        
        saveCancelContainerView.hidden = false;
        doneButton.hidden = false;
        setReminderContainerView.hidden = false;
        gratitudeTitle.editable = true;
        gratitudeDetails.editable = true;
        imageUploadDeleteContainer.hidden =false;
        if (selectedImage) {
            deleteImageButton.hidden = false;
            [addEditImage setTitle:@"CHANGE IMAGE" forState:UIControlStateNormal];
        }else{
            deleteImageButton.hidden = true;
            [addEditImage setTitle:@"UPLOAD" forState:UIControlStateNormal];
        }
        songView.hidden = NO;//song19
        [player pause];     //song19
        
    }
    //if (editButton.hidden && copyButton.hidden) {
    if (editButton.hidden) {
        editCopyContainerViewEdit.hidden = true;
    }else{
        editCopyContainerViewEdit.hidden = false;
    }
    [self prepareReminderView];
}
-(void)prepareReminderView{
    if (reminderSwitch.on) {
        viewReminder.enabled = true;
        [viewReminder setTitle:@"View Reminder Settings:" forState:UIControlStateNormal];
        [viewReminder setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];

    }else{
        viewReminder.enabled = false;
        [viewReminder setTitle:@"Reminder:" forState:UIControlStateNormal];
        [viewReminder setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

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
                                       [self saveButonPressed:nil];
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
    }else{
        response(YES);
    }
}
-(void)saveShareAlert:(NSDictionary*)dict{
    UIAlertController *alertController = [UIAlertController
                                               alertControllerWithTitle:@"Share Type"
                                               message:@""
                                               preferredStyle:UIAlertControllerStyleActionSheet];
         UIAlertAction *action1 = [UIAlertAction
                                    actionWithTitle:@"Text and Pic"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction *action)
                                    {
                                       GratitudePopUpViewController *controller =  [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"GratitudePopUpView"];
                                       controller.modalPresentationStyle = UIModalPresentationCustom;
                                       controller.dict = dict;
                                       controller.type = @"TextWithPic";
                                       [self presentViewController:controller animated:YES completion:nil];
                                    }];
         UIAlertAction *action2 = [UIAlertAction
                                        actionWithTitle:@"Text over pic"
                                        style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction *action)
                                        {
                                           GratitudePopUpViewController *controller =  [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"GratitudePopUpView"];
                                            controller.modalPresentationStyle = UIModalPresentationCustom;
                                            controller.dict = dict;
                                            controller.type = @"TextOverPic";
                                            [self presentViewController:controller animated:YES completion:nil];
                                        }];
         UIAlertAction *action3 = [UIAlertAction
                                           actionWithTitle:@"Text only"
                                           style:UIAlertActionStyleDefault
                                           handler:^(UIAlertAction *action)
                                           {
                                            GratitudePopUpViewController *controller =  [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"GratitudePopUpView"];
                                               controller.modalPresentationStyle = UIModalPresentationCustom;
                                               controller.dict = dict;
                                               controller.type = @"";
                                                [self presentViewController:controller animated:YES completion:nil];
                                           }];
        UIAlertAction *action4 = [UIAlertAction
                                  actionWithTitle:@"Cancel"
                                  style:UIAlertActionStyleDefault
                                  handler:^(UIAlertAction *action)
                                  {
                                   
    }];
         [alertController addAction:action1];
         [alertController addAction:action2];
         [alertController addAction:action3];
         [alertController addAction:action4];
         [self presentViewController:alertController animated:YES completion:nil];
}

-(void)reminderAlert{
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Alert"
                                  message:@"Are you sure you want to change the reminder settings?"
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"YES"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                            if (self->reminderSwitch.on) {
                                self->reminderSwitch.on = false;
//                                [self->gratitudeData removeObjectForKey:@"FrequencyId"];
                                [self->gratitudeData setObject:[NSNumber numberWithBool:true] forKey:@"PushNotification"];
                                [self->gratitudeData setObject:[NSNumber numberWithBool:false] forKey:@"Email"];
                                [self prepareReminderView];
                                 
                             } else {
                                  self->reminderSwitch.on = true;
                                    SetReminderViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SetReminder"];
//                                   if ([self->gratitudeData objectForKey:@"FrequencyId"] != nil)
                                       controller.defaultSettingsDict = self->gratitudeData;
                                       controller.reminderDelegate = self;
                                       controller.fromGratitude=true;
                                   if (self->isFirstTimeReminderSet) {
                                       controller.isFirstTime = self->isFirstTimeReminderSet;
                                       self->isFirstTimeReminderSet = false;
                                }
                                 controller.isremoveDailyTwiceDaily = true;
                                controller.view.backgroundColor = [UIColor clearColor];
                                controller.modalPresentationStyle = UIModalPresentationCustom;
                                [self presentViewController:controller animated:YES completion:nil];
                             }
                           
                         }];
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"NO"
                             style:UIAlertActionStyleCancel
                             handler:^(UIAlertAction * action)
                             {
                               self->isReminderSet = false;
                             }];
    
    [alert addAction:ok];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - End
#pragma mark - IBAction

- (IBAction)dateButtonPressed:(UIButton *)sender {
    if (isEdit) {
        DatePickerViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DatePicker"];
        controller.modalPresentationStyle = UIModalPresentationCustom;
        controller.selectedDate = selectedDate;
        controller.datePickerMode = UIDatePickerModeDate;
        controller.delegate = self;
        [self presentViewController:controller animated:YES completion:nil];
    }
}


- (IBAction)viewReminderButtonPresed:(UIButton *)sender {
    statusOfReminder = true;
    SetReminderViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SetReminder"];
//    if ([gratitudeData objectForKey:@"FrequencyId"] != nil)
    controller.defaultSettingsDict = gratitudeData;
    controller.reminderDelegate = self;
    controller.isFromReminder = true;
    controller.isremoveDailyTwiceDaily = true;
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

-(IBAction)btnClickedDone:(id)sender{
    [self.view endEditing:YES];
}
- (IBAction)reminderSwitch:(UISwitch *)sender {
    isChanged = true;
    [Utility startFlashingbutton:saveButton];
        if ([sender isOn]) {
            if ((![Utility isEmptyCheck:[gratitudeData objectForKey:@"PushNotification"]] && [[gratitudeData objectForKey:@"PushNotification"] boolValue]) || (![Utility isEmptyCheck:[gratitudeData objectForKey:@"Email"]] && [[gratitudeData objectForKey:@"Email"] boolValue])) {
                   statusOfReminder = true;
               }else{
                   statusOfReminder = false;
               }
            SetReminderViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SetReminder"];
            
            if ([Utility isEmptyCheck:[gratitudeData objectForKey:@"FrequencyId"]]){
                [gratitudeData setObject:[NSNumber numberWithInt:1] forKey:@"FrequencyId"];
                [gratitudeData setObject:[NSNumber numberWithInt:1] forKey:@"MonthReminder"];
                [gratitudeData setObject:[NSNumber numberWithInt:43200] forKey:@"ReminderAt1"];
                [gratitudeData setObject:[NSNumber numberWithInt:43200] forKey:@"ReminderAt2"];
                [gratitudeData setObject:[NSNumber numberWithInt:1] forKey:@"ReminderOption"];
                
            }
//            if ([gratitudeData objectForKey:@"FrequencyId"] != nil)
            [gratitudeData setObject:[NSNumber numberWithBool:true] forKey:@"PushNotification"];
            controller.defaultSettingsDict = gratitudeData;
            controller.reminderDelegate = self;
            controller.fromGratitude=true;
            if (isFirstTimeReminderSet) {
                controller.isFirstTime = isFirstTimeReminderSet;
                isFirstTimeReminderSet = false;
            }
            if (_isFromListReminder) {
               controller.isFromReminder = true;
           }
            controller.view.backgroundColor = [UIColor clearColor];
            controller.modalPresentationStyle = UIModalPresentationCustom;
            controller.isremoveDailyTwiceDaily = true;
            [self presentViewController:controller animated:YES completion:nil];
        } else {
//                [gratitudeData removeObjectForKey:@"FrequencyId"];
                UIAlertController * alert=   [UIAlertController
                                                 alertControllerWithTitle:nil
                                                 message:nil
                                                 preferredStyle:UIAlertControllerStyleAlert];
                   
                   UIAlertAction* editReminder = [UIAlertAction
                                        actionWithTitle:@"EDIT REMINDER"
                                        style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction * action)
                                        {
                                         self->statusOfReminder = true;
                                          SetReminderViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SetReminder"];
                                          //            if ([gratitudeData objectForKey:@"FrequencyId"] != nil)
                                                      controller.defaultSettingsDict = self->gratitudeData;
                                                      controller.reminderDelegate = self;
                                                      controller.fromGratitude=true;
                                                      if (self->isFirstTimeReminderSet) {
                                                          controller.isFirstTime = self->isFirstTimeReminderSet;
                                                          self->isFirstTimeReminderSet = false;
                                                      }
                                                      controller.isFromReminder = true;
                                                      controller.isremoveDailyTwiceDaily = true;
                                                      controller.view.backgroundColor = [UIColor clearColor];
                                                      controller.modalPresentationStyle = UIModalPresentationCustom;
                                                      [self presentViewController:controller animated:YES completion:nil];
                                        }];
                   UIAlertAction* turnOffReminder = [UIAlertAction
                                            actionWithTitle:@"TURN OFF REMINDER"
                                            style:UIAlertActionStyleCancel
                                            handler:^(UIAlertAction * action)
                                            {
                                                self->statusOfReminder = false;
                                                self->isChanged=true;
                                                   [self->gratitudeData setObject:[NSNumber numberWithBool:false] forKey:@"PushNotification"];
                                                   [self->gratitudeData setObject:[NSNumber numberWithBool:false] forKey:@"Email"];
                                                   [self->gratitudeData setObject:[NSNumber numberWithInt:1] forKey:@"FrequencyId"];
                                                   [self prepareReminderView];
                                            }];
              
                   [alert addAction:editReminder];
                   [alert addAction:turnOffReminder];
                   [self presentViewController:alert animated:YES completion:nil];

            }
             
        }
- (IBAction)deleteImageButtonPressed:(id)sender {
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Delete confirmation"
                                  message:@"Are you sure you want to delete the uploaded file?"
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"Confirm"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             self->deleteImageButton.hidden = true;
                             self->selectedImage = nil;
                             self->gratudeImageView.image = [UIImage imageNamed:@"upload_image.png"];
                             [self->gratitudeData removeObjectForKey:@"UploadPictureImgFileName"];
                            if(![Utility isEmptyCheck:self->localImageName]){
                                [Utility removeImage:self->localImageName];
                            }
                             //[self saveDataMultiPart];
                         }];
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"No"
                             style:UIAlertActionStyleCancel
                             handler:^(UIAlertAction * action)
                             {
                                 NSLog(@"Resolving UIAlertActionController for tapping cancel button");
                                 
                             }];
    [alert addAction:cancel];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}
- (IBAction)uploadImageButtonPressed:(id)sender {
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

- (IBAction)saveButonPressed:(UIButton *)sender {
    [self saveDataMultiPart];
}

 - (IBAction)deleteButonPressed:(UIButton *)sender {
         UIAlertController * alert=   [UIAlertController
         alertControllerWithTitle:@"Delete confirmation"
         message:@"Are you sure you want to delete this gratitude??"
         preferredStyle:UIAlertControllerStyleAlert];
     
         UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"Confirm"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                              {
                                        [self delete];
                                         NSArray *requests = [[UIApplication sharedApplication] scheduledLocalNotifications];
                                         for (UILocalNotification *req in requests) {
                                         NSString *pushTo = [req.userInfo objectForKey:@"pushTo"];
                                         if ([pushTo caseInsensitiveCompare:@"Gratitude"] == NSOrderedSame) {
                                         int bucketRemID = [[req.userInfo objectForKey:@"ID"] intValue];
                                         if (bucketRemID == [[self->gratitudeData objectForKey:@"Id"] intValue]) {
                                         [[UIApplication sharedApplication] cancelLocalNotification:req];
                                     }
                                    }
                                 }
                              }];
         UIAlertAction* cancel = [UIAlertAction
                                 actionWithTitle:@"No"
                                 style:UIAlertActionStyleCancel
                                 handler:^(UIAlertAction * action)
                                {
                                    NSLog(@"Resolving UIAlertActionController for tapping cancel button");
                                }];
     
         [alert addAction:ok];
         [alert addAction:cancel];
         [self presentViewController:alert animated:YES completion:nil];
 
 }

- (IBAction)backButtonPressed:(UIButton *)sender {
    if (isTitleSave) {
        isTitleSave = false;
        if([self->gratitudeDelegate respondsToSelector:@selector(didGratitudeBackAction:)]){
               [self->gratitudeDelegate didGratitudeBackAction:self->isLoad];
           }
    }
 
    if (isEdit) {
        [self shouldPopOnBackButtonWithResponse:^(BOOL shouldPop) {
            if (shouldPop) {
                if (![Utility isEmptyCheck:self->gratitudeData]) {
//                    self->isEdit = NO;
//                    self->isChanged = NO;
//                    [self prepareView];
                    [self.navigationController popViewControllerAnimated:YES];

                }else {
                    [self.navigationController popViewControllerAnimated:YES];

                }
            }
        }];
    }else {
        // [self dismissViewControllerAnimated:YES completion:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }
    //[player pause];
}
- (IBAction)editButonPressed:(UIButton *)sender {
    if (gratitudeData) {
        if (isEdit) {
            isEdit= false;
        }else{
            isEdit = true;
        }
        [self prepareView];
    }
}
-(IBAction)infobuttonPressed:(id)sender{
    [Utility showHelpAlertWithURL:@"https://player.vimeo.com/external/125750379.m3u8?s=c85a3928071e47c744698cf66662e8543adcf3f8" controller:self haveToPop:NO];
}
-(IBAction)gratitudeTitlePressed:(id)sender{
      NotesViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NotesView"];
       controller.addEditPageDict = gratitudeData;
       controller.notesDelegate = self;
       controller.fromStr = @"GratituteEdit";
       controller.growthStr = gratitudeTitle.text;
       controller.notesDelegate = self;
       controller.isFromTitle = true;
       [self.navigationController pushViewController:controller animated:YES];
}
-(IBAction)saveShareButtonPressed:(id)sender{
//    if ([Utility isEmptyCheck:selectedImage]) {
//        [Utility msg:@"Please add a pic that you want to share" title:@"" controller:self haveToPop:NO];
//    }else{
    if (isChanged) {
        isTrueShare = true;
        [self saveButonPressed:nil];
    }else{
        self->showPicTypeView.hidden = false;
        self->shareDict =gratitudeData;
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
#pragma mark - ViewLifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    //Ru
    [gratefulView setHidden:TRUE];
    
    NSLog(@"%@", gratitudeData);
    NSLog(@"CurrentFile Name: %@",[Utility createImageFileNameFromTimeStamp]);
    localImageName = [Utility createImageFileNameFromTimeStamp];
    
//    saveButton.layer.borderColor = [UIColor colorWithRed:20.0 / 255.0 green:227.0 / 255.0 blue:209.0 / 255.0 alpha:1.0].CGColor;
    saveButton.clipsToBounds = YES;
//    saveButton.layer.borderWidth = 1.2;
    saveButton.layer.cornerRadius = 15;
    
    addEditImage.layer.borderColor = [UIColor colorWithRed:20.0 / 255.0 green:227.0 / 255.0 blue:209.0 / 255.0 alpha:1.0].CGColor;
    addEditImage.clipsToBounds = YES;
    addEditImage.layer.borderWidth = 1.2;
    addEditImage.layer.cornerRadius = 15;
    
    deleteButton.layer.cornerRadius = 15;
    deleteButton.layer.masksToBounds = YES;
    
    gratitudeShareButton.layer.cornerRadius = 15;
    gratitudeShareButton.layer.masksToBounds = YES;
    [gratitudeShareButton setBackgroundColor:[UIColor grayColor]];
    [gratitudeShareButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [deleteButton setBackgroundColor:[UIColor grayColor]];
    [deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //Ru
    savedReminderDict = [[NSMutableDictionary alloc] init];
    
    for (UIButton *btn in buttonArr) {
        btn.layer.cornerRadius = 9;
        btn.layer.masksToBounds = YES;
    }
    isChanged = NO;
    isFirstTime = YES; //song19
    isFirstTimeReminderSet = true; //gami_badge_popup
    
    toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)]; //toolbar is uitoolbar object
    toolBar.barStyle = UIBarStyleBlackOpaque;
    toolBar.translucent = YES;
    
    gratitudeTitle.text = @"Add Gratitude";
    gratitudeTitle.textColor = [UIColor lightGrayColor]; //optional
    gratitudeDetails.text = @"Tap to start writing";
    
    UIBarButtonItem *btnDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(btnClickedDone:)];
    [toolBar setItems:[NSArray arrayWithObject:btnDone]];
    [self registerForKeyboardNotifications];
    
    NSLog(@"%d",[defaults boolForKey:@"isFirstTimeGratitude"]);
    if ([Utility isEmptyCheck:[defaults objectForKey:@"isFirstTimeGratitude"]] || ![defaults boolForKey:@"isFirstTimeGratitude"]) {
//          [Utility showHelpAlertWithURL:@"https://player.vimeo.com/external/125750379.m3u8?s=c85a3928071e47c744698cf66662e8543adcf3f8" controller:self haveToPop:NO];
          [defaults setObject:[NSNumber numberWithBool:true] forKey:@"isFirstTimeGratitude"];
      }
    
    
}
-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    isTrueShare = false;
    [saveButton setBackgroundColor:[UIColor grayColor]];
    isReminderSet = false;
    if (isFirstTime) {
        isFirstTime = NO;
        if (![Utility isEmptyCheck:gratitudeData]) {
            [self getGratitudeSelectApiCall];
        }else{
            gratitudeData = [[NSMutableDictionary alloc]init];
        }
//        [self prepareView];
        // [self editButonPressed:nil];
    }
   [[NSNotificationCenter defaultCenter] addObserverForName:@"reloadGratitudeEditView" object:Nil queue:Nil usingBlock:^(NSNotification * notification) {
       self->isEdit = false;
        [self getGratitudeSelectApiCall];
   }];
    // [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(checkForChange:) name:@"backButtonPressed" object:nil];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [self.view endEditing:YES];
    
    //  [[NSNotificationCenter defaultCenter] removeObserver:self name:@"backButtonPressed" object:nil];
}
#pragma mark - End

#pragma mark - KeyboardNotifications
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
    activeTextView = nil;
    isChanged = YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    activeTextField = nil;
}
#pragma mark - End
#pragma mark - textView Delegate
- (BOOL)textView:(UITextView *)txtView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    [self.view layoutIfNeeded];
    return YES;
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
//    if (textView == gratitudeDetails) {
//        NotesViewController *controller =[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NotesView"];
//        controller.notesDelegate = self;
//        controller.htmlEditText = textView.accessibilityHint;
//        controller.modalPresentationStyle = UIModalPresentationCustom;
//        [self presentViewController:controller animated:NO completion:nil];
//    }else{
//        [textView setInputAccessoryView:toolBar];
//    }
    activeTextView = textView;
    [textView setInputAccessoryView:toolBar];
    return YES;
}
//gratitudeDetails
- (void)textViewDidBeginEditing:(UITextView *)textView{
   [Utility startFlashingbutton:saveButton];
    activeTextView = textView;
    activeTextField = nil;
    isChanged = YES;
    
    if(gratitudeTitle == textView){
        if ([textView.text isEqualToString:@"Add Gratitude"]) {
            textView.text = @"";
            gratitudeTitle.textColor = [UIColor colorWithRed:20.0 / 255.0 green:227.0 / 255.0 blue:209.0 / 255.0 alpha:1.0];
        }
    }else if(gratitudeDetails ==  textView){
        if ([gratitudeDetails.text isEqualToString:@"Tap to start writing"])
        {
            gratitudeDetails.text = @"";
        }
    }
//    if (textView == gratitudeDetails) {
//        [self.view endEditing:true];
//    }else{
//        [textView becomeFirstResponder];
//    }
    [textView becomeFirstResponder];
}
- (void)textViewDidEndEditing:(UITextView *)textView{
   
    activeTextView = nil;
    if(gratitudeTitle.text.length == 0){
        gratitudeTitle.textColor = [UIColor lightGrayColor];
        gratitudeTitle.text = @"Add Gratitude";
        [gratitudeTitle resignFirstResponder];
    }
    if(gratitudeDetails.text.length == 0){
        gratitudeDetails.text = @"Tap to start writing";
        [gratitudeDetails resignFirstResponder];
    }
//    if (textView == gratitudeDetails) {
//        [self.view endEditing:true];
//    }
}
#pragma mark - End

#pragma mark - SongListDelegate
- (void) getSelectedSongName:(NSString *)name Url:(NSString *)songUrlStr {
    NSLog(@"su %@",songUrlStr);
    isChanged = YES;
    [selectSongButton setAccessibilityHint:songUrlStr];
    [selectSongButton setTitle:name forState:UIControlStateNormal];
    NSString *saveSongDataStr = [NSString stringWithFormat:@"%@*##*%@",songUrlStr,name];
    [gratitudeData setObject:saveSongDataStr forKey:@"Song"];      //ah song
    
}
#pragma mark - End

#pragma mark - Reminder Delegate

-(void) reminderSettingsValue:(NSMutableDictionary *)reminderDict {
    NSLog(@"rem %@",reminderDict);
    isChanged = YES;
    savedReminderDict = reminderDict;   //ah ln1
    [gratitudeData addEntriesFromDictionary:reminderDict];
    if ((![Utility isEmptyCheck:[gratitudeData objectForKey:@"PushNotification"]] && [[gratitudeData objectForKey:@"PushNotification"] boolValue]) || (![Utility isEmptyCheck:[gratitudeData objectForKey:@"Email"]] && [[gratitudeData objectForKey:@"Email"] boolValue])) {
        reminderSwitch.on = true;
    }else{
        reminderSwitch.on = false;
    }
    [Utility startFlashingbutton:saveButton];
    [self prepareReminderView];
}
-(void) cancelReminder {
    reminderSwitch.on = statusOfReminder;
    isChanged = false;
//    [Utility stopFlashingbutton:saveButton];
//    if ([gratitudeData objectForKey:@"FrequencyId"] != nil && ((![Utility isEmptyCheck:[gratitudeData objectForKey:@"PushNotification"]] && [[gratitudeData objectForKey:@"PushNotification"] boolValue]) || (![Utility isEmptyCheck:[gratitudeData objectForKey:@"Email"]] && [[gratitudeData objectForKey:@"Email"] boolValue]))) {
//         [reminderSwitch setOn:YES];
//
//    }else {
//        [reminderSwitch setOn:NO];
////        [gratitudeData removeObjectForKey:@"FrequencyId"];
//    }
    [self prepareReminderView];
}

#pragma mark - End

#pragma mark progressbar delegate

- (void) completedWithResponse:(NSString *)responseString responseDict:(NSDictionary *)responseDict{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"SuccessFlag"] boolValue]) {
            self->isChanged = NO;
            [Utility stopFlashingbutton:self->saveButton];
            [Utility stopFlashingbutton:self->doneButton];
            
            //gami_badge_popup
            if (self->_isNewGratitude) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateBadgePoint" object:self];//gami_badge_popup
            } //gami_badge_popup
            
            if (self->reminderSwitch.isOn && ![Utility isEmptyCheck:self->savedReminderDict] && [[self->savedReminderDict objectForKey:@"PushNotification"] boolValue]) {
                
                if ([Utility isEmptyCheck:self->gratitudeData]) {
                    self->gratitudeData = [[responseDict objectForKey:@"Details"] mutableCopy];
                } else {
                    [self->gratitudeData setObject:[[responseDict objectForKey:@"Details"] objectForKey:@"Id"] forKey:@"Id"];
                }
                self->gratitudeData  = [[Utility replaceDictionaryNullValue:self->gratitudeData] mutableCopy];
                //if (SYSTEM_VERSION_LESS_THAN(@"10")) {
                [SetReminderViewController setOldLocalNotificationFromDictionary:self->savedReminderDict ExtraData:self->gratitudeData FromController:@"Gratitude" Title:self->gratitudeTitle.text Type:@"Gratitude" Id:[[self->gratitudeData objectForKey:@"Id"] intValue]];
            }
            
            
              [Utility saveImageDetails:self->localImageName imagetype:GratitudeList Itemid:[[[responseDict objectForKey:@"Details"] objectForKey:@"Id"]intValue] existingImageChange:self->isExistingImageChange selectedImage:self->selectedImage];
            
            
            
            UIAlertController *alertController = [UIAlertController
                                                  alertControllerWithTitle:@"Success"
                                                  message:@"Gratitude Saved Successfully. "
                                                  preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction
                                       actionWithTitle:@"OK"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction *action)
                                       {
                
                                            if(![Utility isEmptyCheck:self->prvlocalImageName]){
                                                [Utility removeImage:self->prvlocalImageName];
                                            }
                                                                       //Ru
                                           if([self->gratitudeDelegate respondsToSelector:@selector(didGratitudeBackAction:)]){
                                               [self->gratitudeDelegate didGratitudeBackAction:self->isLoad];
                                           }
                                          if (self->isTrueShare) {
                                              self->isTrueShare = false;
                                              self->showPicTypeView.hidden = false;
                                              self->shareDict = responseDict[@"Details"];
//                                              [Utility saveShareAlert:responseDict[@"Details"]with:self];
                                             
                                          }else{
                                              [self.navigationController popViewControllerAnimated:YES];
                                          }
                                       }];
            [alertController addAction:okAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }else{
            [Utility msg:[responseDict objectForKey:@"ErrorMessage"] title:@"Error !" controller:self haveToPop:NO];
            return;
        }
    });
}
- (void) completedWithError:(NSError *)error{
    [Utility msg:error.localizedDescription title:@"Error !" controller:self haveToPop:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Notes Delegate
-(void)saveButtonDetails:(NSString *)saveText with:(UITextView *)textview{
    [textview setContentOffset:CGPointZero animated:NO];
    gratitudeDetails.attributedText = [Utility converHtmltotext:saveText];
    gratitudeDetails.accessibilityHint = saveText;
}
-(void)cancelNotes{
}
-(void)saveButtonDetails:(NSString *)saveText{
    isTitleSave = true;
    gratitudeTitle.text = saveText;
}

#pragma  mark -DatePickerViewControllerDelegate
-(void)didSelectDate:(NSDate *)date{
    NSLog(@"%@",date);
    if (date) {
        isChanged = YES;
        [Utility startFlashingbutton:saveButton];
        static NSDateFormatter *dateFormatter;
        dateFormatter = [NSDateFormatter new];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
        selectedDate = date;
        [dateFormatter setDateFormat:@"MMM d yyyy"];
        NSString *dateString = [dateFormatter stringFromDate:date];
        [dateButton setTitle:dateString forState:UIControlStateNormal];
    }
}
#pragma  mark -End

@end
