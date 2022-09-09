//
//  AchievementsAddEditViewController.m
//  Squad
//
//  Created by AQB Solutions-Mac Mini 2 on 16/03/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import "AchievementsAddEditViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "SongPlayListViewController.h"


#import <AVKit/AVKit.h> //song19
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

@interface AchievementsAddEditViewController (){
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
    IBOutlet UIButton *categoryButton;
    
    IBOutlet UIImageView *achievementImageView;
    IBOutlet UIView *setReminderContainerView;
    IBOutlet UIView *categoryContainerView;
    IBOutlet NSLayoutConstraint *categoryContainerViewHeightConstraint;

    IBOutlet UIButton *deleteImageButton;
    IBOutlet UIButton *addEditImage;
    IBOutlet UIView *imageUploadDeleteContainer;
    
    IBOutlet UITextView *achievementDetails;
    IBOutlet UITextView *achievementTitle;

    IBOutlet NSLayoutConstraint *imageViewHeightConstraint;   //ah 22.3
    IBOutlet UIButton *selectSongButton;//song19
    IBOutlet UIView *songView;//song19
    
    
    IBOutlet UISwitch *reminderSwitch;
    UIView *contentView;
    UITextField *activeTextField;
    UITextView *activeTextView;
    UIToolbar *toolBar;
    UIImage *selectedImage;
    NSArray *categoryArray;
    NSDictionary *selectedCategoryDict;
    int apiCallCount;
    BOOL isCopy;
    AVAudioPlayer *player;//song19
    BOOL isFirstTime;//song19

    NSMutableDictionary *savedReminderDict;     //ah ln1
    
    BOOL isChanged;
    NSString *localImageName;
    NSString *prvlocalImageName;
    BOOL statusOfReminder;
    BOOL isExistingImageChange;
    BOOL isTitleSave;
}

@end

@implementation AchievementsAddEditViewController
@synthesize isEdit,achievementsData,achievementDelegate;

#pragma mark - UIImagePickerControllerDelegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    isChanged=YES;
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    image =[Utility scaleImage:image width:image.size.width height:image.size.height];
    achievementImageView.image = image;
    selectedImage=image;
    isExistingImageChange = true;
    [addEditImage setTitle:@"Change Image" forState:UIControlStateNormal];
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
//        [Utility startFlashingbutton:self->saveButton];
//        [Utility startFlashingbutton:self->doneButton];
    }];
    //    userImageView.image = croppedImage;
    //    UIImage *image=[self scaleImage:croppedImage];
    achievementImageView.image = croppedImage;
    selectedImage = croppedImage;
    [addEditImage setTitle:@"Change Image" forState:UIControlStateNormal];
    deleteImageButton.hidden = false;
    isExistingImageChange = true;
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
//        [Utility startFlashingbutton:self->saveButton];
//        [Utility startFlashingbutton:self->doneButton];
    }];
}


#pragma mark - PrivateMethod
-(void)getCategory {
    if (Utility.reachable) {
        
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
        dispatch_async(dispatch_get_main_queue(), ^{
            self->apiCallCount++;
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
            self->contentView = [Utility activityIndicatorView:self];
        });
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetCategoryAPI" append:@"" forAction:@"POST"];
        
        NSURLSessionDataTask * dataTask =[achieveSession dataTaskWithRequest:request
                                                           completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                               dispatch_async(dispatch_get_main_queue(),^ {
                                                                   self->apiCallCount--;
                                                                   if (self->contentView && self->apiCallCount == 0) {
                                                                       [self->contentView removeFromSuperview];
                                                                   }
                                                                   if(error == nil)
                                                                   {
                                                                       NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                       NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                       if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDictionary] && [[responseDictionary objectForKey:@"SuccessFlag"] boolValue]) {
                                                                           
                                                                           self->categoryArray = [responseDictionary objectForKey:@"Details"];
                                                                           if (self->categoryArray.count > 0) {
                                                                               if (![Utility isEmptyCheck:self->achievementsData]) {
                                                                                   if (![Utility isEmptyCheck:[self->achievementsData objectForKey:@"CategoryId"]]) {
                                                                                       NSDictionary *selectedDict = [Utility getDictByValue:self->categoryArray value:[self->achievementsData objectForKey:@"CategoryId"] type:@"id"];
                                                                                       if ([Utility isEmptyCheck:selectedDict]) {
                                                                                           selectedDict = self->categoryArray[0];
                                                                                       }
                                                                                       self->selectedCategoryDict = selectedDict;
                                                                                       [self->categoryButton setTitle:[selectedDict objectForKey:@"CategoryName"] forState:UIControlStateNormal];
                                                                                   }else{
                                                                                       NSDictionary *selectedDict = self->categoryArray[0];
                                                                                       self->selectedCategoryDict = selectedDict;
                                                                                       [self->categoryButton setTitle:[selectedDict objectForKey:@"CategoryName"] forState:UIControlStateNormal];
                                                                                   }
                                                                                   
                                                                               }else{
                                                                                   NSDictionary *selectedDict = self->categoryArray[0];
                                                                                   self->selectedCategoryDict = selectedDict;
                                                                                   [self->categoryButton setTitle:[selectedDict objectForKey:@"CategoryName"] forState:UIControlStateNormal];
                                                                               }
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
-(void)getAchievementDataApiCall{
    if (Utility.reachable) {
        
        NSURLSession *achieveSession = [NSURLSession sharedSession];
        
        NSError *error;
        
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:[achievementsData objectForKey:@"Id"] forKey:@"ReverseBuckeId"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
            apiCallCount++;
            contentView = [Utility activityIndicatorView:self];
        });
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetReverseBuckeSelectApiCall" append:@"" forAction:@"POST"];
        
        NSURLSessionDataTask * dataTask =[achieveSession dataTaskWithRequest:request
                                                           completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                               dispatch_async(dispatch_get_main_queue(),^ {
                                                                   self->apiCallCount--;
                                                                   if (self->contentView && self->apiCallCount == 0) {
                                                                       [self->contentView removeFromSuperview];
                                                                   }
                                                                   if(error == nil)
                                                                   {
                                                                       NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                       NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                       if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDictionary] && [[responseDictionary objectForKey:@"SuccessFlag"] boolValue]) {
                                                                           self->achievementsData = [[responseDictionary objectForKey:@"Details"] mutableCopy];
                                                                           if (![Utility isEmptyCheck:self->achievementsData]) {
                                                                                [self editButonPressed:0];
                                                                               if (self->_isFromListReminder) {
                                                                                   self->reminderSwitch.on = true;
                                                                                   [self reminderSwitch:self->reminderSwitch];
                                                                               }
                                                                           }else{
                                                                               self->achievementsData = [[NSMutableDictionary alloc]init];
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
        [mainDict setObject:[achievementsData valueForKey:@"Id"] forKey:@"ReverseBucketID"];
        
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"DeleteReverseBucketApiCall" append:@"" forAction:@"POST"];
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
                                                                                                               message:@"Growth Deleted Successfully. "
                                                                                                               preferredStyle:UIAlertControllerStyleAlert];
                                                                         UIAlertAction *okAction = [UIAlertAction
                                                                                                    actionWithTitle:@"OK"
                                                                                                    style:UIAlertActionStyleDefault
                                                                                                    handler:^(UIAlertAction *action)
                                                                                                    {
                                                                                                    [[NSNotificationCenter defaultCenter]postNotificationName:@"AchivementDelete" object:self userInfo:nil];
//                                                                                                        if ([self->achievementDelegate respondsToSelector:@selector(didAchievementsBackAction:)]) {
//                                                                                                            [self->achievementDelegate didAchievementsBackAction:true];
//                                                                                                        }
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
            [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:YES];
            return;
        });
        
    }
}
-(void) saveDataMultiPart {
    if (Utility.reachable) {
        if (![Utility isEmptyCheck:achievementTitle.text] && achievementTitle.text.length > 0 && ![achievementTitle.text isEqualToString:@"Add Achievement"]) {
            [achievementsData setObject:achievementTitle.text forKey:@"Achievement"];
            
        }else{
            [Utility msg:@"Name is required " title:@"Error" controller:self haveToPop:NO];
            return;
        }
        if (![Utility isEmptyCheck:selectedCategoryDict]) {
            [achievementsData setObject:selectedCategoryDict[@"id"] forKey:@"CategoryId"];
            
        }else{
            [Utility msg:@"Please Select Category " title:@"Error" controller:self haveToPop:NO];
            return;
        }

        if (![Utility isEmptyCheck:achievementDetails.text]) {
            [achievementsData setObject:achievementDetails.text forKey:@"Notes"];
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
        if (achievementsData[@"Id"] == nil || isCopy) {
            [achievementsData setObject:[NSNumber numberWithInteger:0] forKey:@"Id"];
        }
        if (achievementsData[@"CreatedBy"] == nil) {
            [achievementsData setObject:[defaults valueForKey:@"UserID"] forKey:@"CreatedBy"];
        }
        
        if(![Utility isEmptyCheck:localImageName]){
            [achievementsData setObject:localImageName forKey:@"PictureDevicePath"];
        }else{
            [achievementsData setObject:@"" forKey:@"PictureDevicePath"];
        }
        
        [achievementsData setObject:@"" forKey:@"UploadPictureImgBase64"];
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
        //controller.chosenImage=selectedImage;
        controller.chosenImage=nil;
        controller.modalPresentationStyle = UIModalPresentationCustom;
        [self presentViewController:controller animated:YES completion:nil];
    }else{
        [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
    }
    
}
-(void) saveData {
    if (Utility.reachable) {
        if (![Utility isEmptyCheck:achievementTitle.text] && achievementTitle.text.length > 0 && ![achievementTitle.text isEqualToString:@"Add Achievement"]) {
            [achievementsData setObject:achievementTitle.text forKey:@"Achievement"];
            
        }else{
            [Utility msg:@"Name is required " title:@"Error" controller:self haveToPop:NO];
            return;
        }
        if (![Utility isEmptyCheck:selectedCategoryDict]) {
            [achievementsData setObject:selectedCategoryDict[@"id"] forKey:@"CategoryId"];
            
        }else{
            [Utility msg:@"Please Select Category " title:@"Error" controller:self haveToPop:NO];
            return;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
            self->contentView = [Utility activityIndicatorView:self];
        });
        if (![Utility isEmptyCheck:achievementDetails.text]) {
            [achievementsData setObject:achievementDetails.text forKey:@"Notes"];
        }
        
        NSURLSession *achieveSession = [NSURLSession sharedSession];
        
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
        if (achievementsData[@"Id"] == nil || isCopy) {
            [achievementsData setObject:[NSNumber numberWithInteger:0] forKey:@"Id"];
        }
        if (achievementsData[@"CreatedBy"] == nil) {
            [achievementsData setObject:[defaults valueForKey:@"UserID"] forKey:@"CreatedBy"];
        }
        
        if (![Utility isEmptyCheck:selectedImage]) {
            NSString *imgBase64Str = [UIImagePNGRepresentation(selectedImage) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
            [achievementsData setObject:imgBase64Str forKey:@"UploadPictureImgBase64"];
        }else{
            [achievementsData setObject:@"" forKey:@"UploadPictureImgBase64"];
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
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"AddUpdateReverseBucketApiCall" append:@"" forAction:@"POST"];
        
        NSURLSessionDataTask * dataTask =[achieveSession dataTaskWithRequest:request
                                                           completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                               dispatch_async(dispatch_get_main_queue(),^ {
                                                                   if (contentView) {
                                                                       [contentView removeFromSuperview];
                                                                   }
                                                                   if(error == nil)
                                                                   {
                                                                       NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                       NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                       if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDictionary] && [[responseDictionary objectForKey:@"SuccessFlag"] boolValue]) {
                                                                           
                                                                           //ah ln1
                                                                           if (reminderSwitch.isOn && ![Utility isEmptyCheck:savedReminderDict] && [[savedReminderDict objectForKey:@"PushNotification"] boolValue]) {
                                                                               
                                                                               if ([Utility isEmptyCheck:achievementsData]) {
                                                                                   achievementsData = [[responseDictionary objectForKey:@"Details"] mutableCopy];
                                                                               } else {
                                                                                   achievementsData = [[NSMutableDictionary alloc] init];
                                                                                   [achievementsData setObject:[[responseDictionary objectForKey:@"Details"] objectForKey:@"Id"] forKey:@"Id"];
                                                                               }
                                                                               
                                                                               //if (SYSTEM_VERSION_LESS_THAN(@"10")) {
                                                                               [SetReminderViewController setOldLocalNotificationFromDictionary:savedReminderDict ExtraData:achievementsData FromController:@"Achievement" Title:achievementTitle.text Type:@"Achievement" Id:[[achievementsData objectForKey:@"Id"] intValue]];
                                                                               
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
    if (![Utility isEmptyCheck:achievementsData]) {
        NSString *name = achievementsData[@"Achievement"];
        achievementTitle.text = ![Utility isEmptyCheck:name] ? name : @"Add Achievement";
        if (![achievementTitle.text isEqualToString:@"Add Achievement"]) {
            achievementTitle.textColor = [Utility colorWithHexString:@"333333"];//squadMainColor;
        }else{
            achievementTitle.textColor = [UIColor lightGrayColor];
        }
        NSString *description = achievementsData[@"Notes"];
        achievementDetails.text = ![Utility isEmptyCheck:description] ? description :@"";
//        achievementDetails.accessibilityHint =![Utility isEmptyCheck:description] ? description: @"";
        
        
        if(![Utility isEmptyCheck:[achievementsData objectForKey:@"PictureDevicePath"]]){
                   localImageName = [achievementsData objectForKey:@"PictureDevicePath"];
                   selectedImage = [Utility getImageFromDocumentDirectoryWithImageName:localImageName];
                   
                   if(selectedImage){
                       CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
                       CGFloat imageViewHeight = selectedImage.size.height/selectedImage.size.width * screenWidth;
                       self->imageViewHeightConstraint.constant = imageViewHeight;
                       achievementImageView.image = selectedImage;
                       [addEditImage setTitle:@"CHANGE IMAGE" forState:UIControlStateNormal];
                   }else if (![Utility isEmptyCheck:[achievementsData objectForKey:@"Picture"]]) {
                       NSString *imageUrlString =[achievementsData objectForKey:@"Picture"];
                       [achievementImageView sd_setImageWithURL:[NSURL URLWithString:[imageUrlString stringByAddingPercentEncodingWithAllowedCharacters:
                                                                            [NSCharacterSet URLQueryAllowedCharacterSet]]]
                                     placeholderImage:[UIImage imageNamed:@"img_holder.png"]
                                            options:SDWebImageScaleDownLargeImages completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
                                                  if (image) {
                                                       CGFloat imageViewHeight = image.size.height/image.size.width * screenWidth;
                                                       self->imageViewHeightConstraint.constant = imageViewHeight;
                                                       self->selectedImage = image;
                                                       self->achievementImageView.image = image;
                                                       [self->addEditImage setTitle:@"CHANGE IMAGE" forState:UIControlStateNormal];
                                                   }
                                                   else {
                                                       self->selectedImage = nil;
                                                       self->achievementImageView.image = [UIImage imageNamed:@"upload_image.png"];
                                                       [self->addEditImage setTitle:@"UPLOAD" forState:UIControlStateNormal];
                                                   }
                                                });
                                            }];
                       

                   }
                   else{
                       achievementImageView.image = [UIImage imageNamed:@"upload_image.png"];
                       [addEditImage setTitle:@"UPLOAD" forState:UIControlStateNormal];
                   }
                   
                   
       }else if (![Utility isEmptyCheck:[achievementsData objectForKey:@"Picture"]]) {
           NSString *imageUrlString =[achievementsData objectForKey:@"Picture"];
           [achievementImageView sd_setImageWithURL:[NSURL URLWithString:[imageUrlString stringByAddingPercentEncodingWithAllowedCharacters:
                                                                [NSCharacterSet URLQueryAllowedCharacterSet]]]
                         placeholderImage:[UIImage imageNamed:@"img_holder.png"]
                                options:SDWebImageScaleDownLargeImages completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
                                      if (image) {
                                           CGFloat imageViewHeight = image.size.height/image.size.width * screenWidth;
                                           self->imageViewHeightConstraint.constant = imageViewHeight;
                                           self->selectedImage = image;
                                           self->achievementImageView.image = image;
                                           [self->addEditImage setTitle:@"CHANGE IMAGE" forState:UIControlStateNormal];
                                       }
                                       else {
                                           self->selectedImage = nil;
                                           self->achievementImageView.image = [UIImage imageNamed:@"upload_image.png"];
                                           [self->addEditImage setTitle:@"UPLOAD" forState:UIControlStateNormal];
                                       }
                                    });
                                }];
           

       }else{
           localImageName = [Utility createImageFileNameFromTimeStamp];
           achievementImageView.image = [UIImage imageNamed:@"upload_image.png"];
           [addEditImage setTitle:@"UPLOAD" forState:UIControlStateNormal];
       }
        
       /* NSString *imageUrlString =[achievementsData objectForKey:@"Picture"];
        if (![Utility isEmptyCheck:[achievementsData objectForKey:@"Picture"]]) {
            imageUrlString = [imageUrlString stringByReplacingOccurrencesOfString:@"thumbnails/" withString:@""];
            NSURL *url = [NSURL URLWithString:imageUrlString];
            //[achievementImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"EXERCISE-picture-coming.jpg"] options:SDWebImageRefreshCached];
            achievementImageView.image = [UIImage imageNamed:@"EXERCISE-picture-coming.jpg"];
            SDWebImageManager *manager = [SDWebImageManager sharedManager];
            [manager loadImageWithURL:url
                                  options:0
                                 progress:^(NSInteger receivedSize, NSInteger expectedSize ,NSURL * targetURL) {
                                     // progression tracking code
                                 }
                                completed:^(UIImage *image,NSData *data, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                    //ah 22.3
                                    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
                                    
                                    if (image) {
                                        CGFloat imageViewHeight = image.size.height/image.size.width * screenWidth;
                                        self->imageViewHeightConstraint.constant = imageViewHeight;
                                        self->selectedImage = image;
                                        self->achievementImageView.image = image;
                                        [self->addEditImage setTitle:@"CHANGE IMAGE" forState:UIControlStateNormal];
                                    }
                                    else {
                                        self->selectedImage = nil;
                                        self->achievementImageView.image = [UIImage imageNamed:@"upload_image.png"];
                                        [self->addEditImage setTitle:@"UPLOAD" forState:UIControlStateNormal];
                                    }
                                }];
        }else {
            achievementImageView.image = [UIImage imageNamed:@"upload_image.png"];
            selectedImage = nil;
        }*/
        if ((![Utility isEmptyCheck:[achievementsData objectForKey:@"PushNotification"]] && [[achievementsData objectForKey:@"PushNotification"] boolValue]) || (![Utility isEmptyCheck:[achievementsData objectForKey:@"Email"]] && [[achievementsData objectForKey:@"Email"] boolValue])) {
            savedReminderDict = achievementsData;   //ah ln1
            reminderSwitch.on = true;
        }else{
            reminderSwitch.on = false;
        }
    }
    if (!isEdit){
        if (![Utility isEmptyCheck:achievementsData]) {
            deleteButton.hidden = false;
        }else{
            deleteButton.hidden = true;
        }
        editButton.hidden = false;
        saveCancelContainerView.hidden = true;
        doneButton.hidden = true;
        setReminderContainerView.hidden = true;
        categoryContainerView.hidden = true;
        categoryContainerViewHeightConstraint.constant = 0;
        copyButton.hidden = true;
        achievementTitle.editable = false;
        achievementDetails.editable = false;
        categoryButton.enabled = false;
        imageUploadDeleteContainer.hidden =true;
        
        
        //song19
        songView.hidden = YES;
        
        if (![Utility isEmptyCheck:[achievementsData objectForKey:@"Song"]]) {
            //play song
            NSError *error;
            //            if ([[NSFileManager defaultManager] fileExistsAtPath:[_selectedGoalDict objectForKey:@"Song"]]) { @"%@*#*%@"
            NSArray *songArr = [[achievementsData objectForKey:@"Song"] componentsSeparatedByString:@"*##*"];
            
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
        if (![Utility isEmptyCheck:achievementsData]) {
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
        categoryContainerView.hidden = false;
        categoryContainerViewHeightConstraint.constant = 40;

        achievementTitle.editable = true;
        achievementDetails.editable = true;
        imageUploadDeleteContainer.hidden =false;
        categoryButton.enabled = true;
        songView.hidden = NO;//song19
        [player pause];     //song19

        if (selectedImage) {
            deleteImageButton.hidden = false;
            [addEditImage setTitle:@"CHANGE IMAGE" forState:UIControlStateNormal];
        }else{
            deleteImageButton.hidden = true;
            [addEditImage setTitle:@"UPLOAD" forState:UIControlStateNormal];
        }
    }
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
        [viewReminder setTitleColor:[Utility colorWithHexString:@"333333"] forState:UIControlStateNormal];
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
    } else {
        response(YES);
    }
}

#pragma mark - End

#pragma mark - IBAction
- (IBAction)viewReminder:(UIButton *)sender {
    statusOfReminder = true;
    SetReminderViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SetReminder"];
    if ([achievementsData objectForKey:@"FrequencyId"] != nil)
    controller.defaultSettingsDict = achievementsData;
    controller.reminderDelegate = self;
    controller.isremoveDailyTwiceDaily = true;
    controller.isFromReminder = true;
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
- (IBAction)categoryButtonTapped:(id)sender {
    DropdownViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Dropdown"];
    controller.modalPresentationStyle = UIModalPresentationCustom;
    controller.dropdownDataArray = categoryArray;
    controller.mainKey = @"CategoryName";
    controller.apiType = @"Category";
    if (![Utility isEmptyCheck:selectedCategoryDict]) {
        controller.selectedIndex = (int)[categoryArray indexOfObject:selectedCategoryDict];
    }else{
        controller.selectedIndex =0;
    }
    controller.delegate = self;
    [self presentViewController:controller animated:YES completion:nil];
}
-(IBAction)btnClickedDone:(id)sender{
    [self.view endEditing:YES];
}
- (IBAction)reminderSwitch:(UISwitch *)sender {
    self->isChanged=true;
    [Utility startFlashingbutton:saveButton];
    if ([sender isOn]) {
        if ((![Utility isEmptyCheck:[achievementsData objectForKey:@"PushNotification"]] && [[achievementsData objectForKey:@"PushNotification"] boolValue]) || (![Utility isEmptyCheck:[achievementsData objectForKey:@"Email"]] && [[achievementsData objectForKey:@"Email"] boolValue])) {
            statusOfReminder = true;
        }else{
            statusOfReminder = false;
        }
        SetReminderViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SetReminder"];
        if ([achievementsData objectForKey:@"FrequencyId"] != nil)
            [achievementsData setObject:[NSNumber numberWithBool:true] forKey:@"PushNotification"];
            controller.defaultSettingsDict = achievementsData;
            controller.reminderDelegate = self;
            controller.isremoveDailyTwiceDaily = true;
            if (_isFromListReminder) {
                controller.isFromReminder = true;
            }
            controller.view.backgroundColor = [UIColor clearColor];
            controller.modalPresentationStyle = UIModalPresentationCustom;
            [self presentViewController:controller animated:YES completion:nil];
    } else {
        {

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
                                        if ([self->achievementsData objectForKey:@"FrequencyId"] != nil)
                                                controller.defaultSettingsDict = self->achievementsData;
                                     controller.reminderDelegate = self;
                                     controller.isremoveDailyTwiceDaily = true;
                                     controller.isFromReminder = true;
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
                                                [self->achievementsData setObject:[NSNumber numberWithInt:1] forKey:@"FrequencyId"];
                                                [self->achievementsData setObject:[NSNumber numberWithBool:false] forKey:@"PushNotification"];
                                                [self->achievementsData setObject:[NSNumber numberWithBool:false] forKey:@"Email"];
                                                [self prepareReminderView];
                                                   
                                        }];
          
               [alert addAction:editReminder];
               [alert addAction:turnOffReminder];
               [self presentViewController:alert animated:YES completion:nil];

        }

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
                             self->achievementImageView.image = [UIImage imageNamed:@"upload_image.png"];
                             [self->achievementsData removeObjectForKey:@"UploadPictureImgFileName"];
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
                                [Utility startFlashingbutton:self->saveButton];
                                  [self showCamera];
                              }];
    
    UIAlertAction* button2 = [UIAlertAction
                              actionWithTitle:@"Open Gallery"
                              style:UIAlertActionStyleDefault
                              handler:^(UIAlertAction * action)
                              {
                                    [Utility startFlashingbutton:self->saveButton];
                                  [self openPhotoAlbum];
                              }];
    
    [alert addAction:button0];
    [alert addAction:button1];
    [alert addAction:button2];
    [self presentViewController:alert animated:YES completion:nil];
}
- (IBAction)copyButtonPressed:(id)sender {
    isCopy = true;
    copyButton.hidden = true;
    achievementTitle.text = [@"COPY OF : " stringByAppendingString:achievementTitle.text];
    if (editButton.hidden && copyButton.hidden) {
        editCopyContainerViewEdit.hidden = true;
    }else{
        editCopyContainerViewEdit.hidden = false;
    }
}

- (IBAction)editButonPressed:(UIButton *)sender {
    if (achievementsData) {
        if (isEdit) {
            isEdit= false;
        }else{
            isEdit = true;
        }
        [self prepareView];
    }
    
}
- (IBAction)saveButonPressed:(UIButton *)sender {
    [self saveDataMultiPart];
}
- (IBAction)cancelButonPressed:(UIButton *)sender {
    [self shouldPopOnBackButtonWithResponse:^(BOOL shouldPop) {
        if (shouldPop) {
            if(![Utility isEmptyCheck:self->achievementsData]){
                self->isEdit= false;
                if (self->isCopy) {
                    self->isCopy = false;
                    self->copyButton.hidden = false;
                    NSString *name = self->achievementsData[@"Achievement"];
                    self->achievementTitle.text = ![Utility isEmptyCheck:name] ? name : @"";
                }
                self->isChanged = NO;
                [Utility stopFlashingbutton:self->saveButton];
                [Utility stopFlashingbutton:self->doneButton];
                [self prepareView];
            }else{
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            
        }
    }];
}
- (IBAction)deleteButonPressed:(UIButton *)sender {
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Delete confirmation"
                                  message:@"Are you sure you want to delete this achievement??"
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"Confirm"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [self delete];
                             
                             //ah ln1
                             NSArray *requests = [[UIApplication sharedApplication] scheduledLocalNotifications];
                             for (UILocalNotification *req in requests) {
                                 NSString *pushTo = [req.userInfo objectForKey:@"pushTo"];
                                 if ([pushTo caseInsensitiveCompare:@"Achievement"] == NSOrderedSame) {
                                     int bucketRemID = [[req.userInfo objectForKey:@"ID"] intValue];
                                     if (bucketRemID == [[self->achievementsData objectForKey:@"Id"] intValue]) {
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

- (IBAction)logoButtonPressed:(UIButton *)sender {
    [self shouldPopOnBackButtonWithResponse:^(BOOL shouldPop) {
        if (shouldPop) {
            [self dismissViewControllerAnimated:YES completion:^{
                [self.presentingViewController.navigationController  popToRootViewControllerAnimated:YES];
            }];
        }
    }];
}
- (IBAction)showMenu:(id)sender {
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
    [self.slidingViewController resetTopViewAnimated:YES];
}
- (IBAction)backButtonPressed:(id)sender {
   // [self.navigationController popViewControllerAnimated:YES];
//    isEdit = false;
    if (isTitleSave) {
        isTitleSave = false;
        if ([self->achievementDelegate respondsToSelector:@selector(didAchievementsBackAction:)]) {
               [self->achievementDelegate didAchievementsBackAction:true];
           }
    }
    if (isEdit) {//song19
        [self shouldPopOnBackButtonWithResponse:^(BOOL shouldPop) {
            if (shouldPop) {
                if (![Utility isEmptyCheck:self->achievementsData]) {
//                    isEdit = NO;
//                    isChanged = NO;
//                    [Utility stopFlashingbutton:saveButton];
//                    [Utility stopFlashingbutton:doneButton];
//                    [self prepareView];
                    [self.navigationController popViewControllerAnimated:YES];
                }else {
//                    [self dismissViewControllerAnimated:YES completion:nil];
                    [self.navigationController popViewControllerAnimated:YES];
                }
                
            }
        }];
    }else{
          [self.navigationController popViewControllerAnimated:YES];
    }
    [player pause];
}
-(IBAction)achievementTitlePressed:(id)sender{
      NotesViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NotesView"];
      [achievementsData removeObjectForKey:@"Achievement"];
      [achievementsData setObject:achievementTitle.text forKey:@"Achievement"];
       controller.addEditPageDict = achievementsData;
       controller.notesDelegate = self;
       controller.fromStr = @"GrowthEdit";
       controller.growthStr = achievementTitle.text;
       controller.notesDelegate = self;
       controller.isFromTitle = true;
       [self.navigationController pushViewController:controller animated:YES];
}
#pragma mark - ViewLifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
     isFirstTime = YES; //song19
    NSLog(@"CurrentFile Name: %@",[Utility createImageFileNameFromTimeStamp]);
    localImageName = [Utility createImageFileNameFromTimeStamp];
    savedReminderDict = [[NSMutableDictionary alloc] init];
    isChanged = NO;
    [Utility stopFlashingbutton:saveButton];
    [Utility stopFlashingbutton:doneButton];
    apiCallCount = 0;
    toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)]; //toolbar is uitoolbar object
    toolBar.barStyle = UIBarStyleBlackOpaque;
    toolBar.translucent = YES;
    
    saveButton.layer.cornerRadius = 15;
    saveButton.layer.masksToBounds = YES;
    deleteButton.layer.cornerRadius = 15;
    deleteButton.layer.masksToBounds = YES;
    addEditImage.layer.cornerRadius = 15;
    addEditImage.layer.masksToBounds = YES;
    addEditImage.layer.borderColor = squadMainColor.CGColor;
    addEditImage.layer.borderWidth = 1;
    
    achievementTitle.text = @"Add Achievement";
    achievementTitle.textColor = [UIColor lightGrayColor]; //optional
    achievementDetails.text = @"Tap to start writing";
    
    UIBarButtonItem *btnDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(btnClickedDone:)];
    [toolBar setItems:[NSArray arrayWithObject:btnDone]];
    [Utility stopFlashingbutton:deleteButton];
    [self registerForKeyboardNotifications];
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    if (isFirstTime) {
        isFirstTime = NO;
        dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            if (![Utility isEmptyCheck:self->achievementsData]) {
                [self getAchievementDataApiCall];
            }else{
                self->achievementsData = [[NSMutableDictionary alloc]init];
            }
            [self getCategory];
        });
    }
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [self.view endEditing:YES];
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
    [Utility startFlashingbutton:saveButton];
    activeTextField = textField;
    activeTextView = nil;
    isChanged = YES;
//    [Utility startFlashingbutton:saveButton];
//    [Utility startFlashingbutton:doneButton];
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
//    if (textView == achievementDetails) {
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

- (void)textViewDidBeginEditing:(UITextView *)textView{
    [Utility startFlashingbutton:saveButton];
    activeTextView = textView;
    activeTextField = nil;
    
    if (textView == achievementDetails) {
//        [self.view endEditing:true];
        if([achievementDetails.text caseInsensitiveCompare:@"Tap to start writing"] == NSOrderedSame){
            achievementDetails.text = @"";
        }
    }else{
        [textView becomeFirstResponder];
        if([achievementTitle.text caseInsensitiveCompare:@"Add Achievement"] == NSOrderedSame){
            achievementTitle.text = @"";
            achievementTitle.textColor = [Utility colorWithHexString:@"333333"];// squadMainColor;
        }
    }
    isChanged = YES;
//    [Utility startFlashingbutton:saveButton];
//    [Utility startFlashingbutton:doneButton];
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    activeTextView = nil;
   
    if (textView == achievementDetails) {
//        [self.view endEditing:true];
    }else{
        if(achievementTitle.text.length == 0){
            achievementTitle.textColor = [UIColor lightGrayColor];
            achievementTitle.text = @"Add Achievement";
            [achievementTitle resignFirstResponder];
        }
    }
}

#pragma mark - SongListDelegate
- (void) getSelectedSongName:(NSString *)name Url:(NSString *)songUrlStr {
    NSLog(@"su %@",songUrlStr);
    isChanged = YES;
//    [Utility startFlashingbutton:saveButton];
//    [Utility startFlashingbutton:doneButton];
    [selectSongButton setAccessibilityHint:songUrlStr];
    [selectSongButton setTitle:name forState:UIControlStateNormal];
    NSString *saveSongDataStr = [NSString stringWithFormat:@"%@*##*%@",songUrlStr,name];
    [achievementsData setObject:saveSongDataStr forKey:@"Song"];      //ah song
    
}
#pragma mark - End

#pragma mark - Reminder Delegate

-(void) reminderSettingsValue:(NSMutableDictionary *)reminderDict {
    [Utility startFlashingbutton:saveButton];
    NSLog(@"rem %@",reminderDict);
    isChanged = YES;
    [Utility startFlashingbutton:saveButton];
//    [Utility startFlashingbutton:doneButton];
    savedReminderDict = reminderDict;   //ah ln1
    if ((![Utility isEmptyCheck:[achievementsData objectForKey:@"PushNotification"]] && [[achievementsData objectForKey:@"PushNotification"] boolValue]) || (![Utility isEmptyCheck:[achievementsData objectForKey:@"Email"]] && [[achievementsData objectForKey:@"Email"] boolValue])) {
        reminderSwitch.on = true;
    }else{
        reminderSwitch.on = false;
    }
    [achievementsData addEntriesFromDictionary:reminderDict];
    [self prepareReminderView];
}
-(void) cancelReminder {
//    [Utility stopFlashingbutton:saveButton];
        reminderSwitch.on = statusOfReminder;
//    if ([achievementsData objectForKey:@"FrequencyId"] != nil) {
//
//    }else {
//        [reminderSwitch setOn:NO];
////        [achievementsData removeObjectForKey:@"FrequencyId"];
//    }
    [self prepareReminderView];

}

-(void) dropdownSelected:(NSString *)selectedValue sender:(UIButton *)sender type:(NSString *)type{
    //    NSLog(@"selv %@",selectedValue);
    //    [sender setTitle:selectedValue forState:UIControlStateNormal];
    //    if (sender == goalValuesButton) {
    //
    //    }
}
- (void) didSelectAnyDropdownOption:(NSString *)type data:(NSDictionary *)selectedData{
    [Utility startFlashingbutton:saveButton];
    NSLog(@"ty %@ \ndata %@",type,selectedData);
    isChanged = YES;
//    [Utility startFlashingbutton:saveButton];
//    [Utility startFlashingbutton:doneButton];
    if ([type caseInsensitiveCompare:@"Category"] == NSOrderedSame) {
        selectedCategoryDict =selectedData;
        [categoryButton setTitle:[selectedData objectForKey:@"CategoryName"] forState:UIControlStateNormal];
        [achievementsData setObject:[selectedData objectForKey:@"id"] forKey:@"CategoryId"];
    }
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
            if (self->_isNewReverseBucket) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateBadgePoint" object:self];
            }//gami_badge_popup
            
            if (self->reminderSwitch.isOn && ![Utility isEmptyCheck:self->savedReminderDict] && [[self->savedReminderDict objectForKey:@"PushNotification"] boolValue]) {
                
                if ([Utility isEmptyCheck:self->achievementsData]) {
                    self->achievementsData = [[responseDict objectForKey:@"Details"] mutableCopy];
                } else {
                    self->achievementsData = [[NSMutableDictionary alloc] init];
                    [self->achievementsData setObject:[[responseDict objectForKey:@"Details"] objectForKey:@"Id"] forKey:@"Id"];
                }
                self->achievementsData  = [[Utility replaceDictionaryNullValue:self->achievementsData] mutableCopy];

                //if (SYSTEM_VERSION_LESS_THAN(@"10")) {
                [SetReminderViewController setOldLocalNotificationFromDictionary:self->savedReminderDict ExtraData:self->achievementsData FromController:@"Achievement" Title:self->achievementTitle.text Type:@"Achievement" Id:[[self->achievementsData objectForKey:@"Id"] intValue]];
                
            }
           [Utility saveImageDetails:self->localImageName imagetype:ReverseBucketList Itemid:[[[responseDict objectForKey:@"Details"] objectForKey:@"Id"]intValue] existingImageChange:self->isExistingImageChange selectedImage:self->selectedImage];
             
         
            UIAlertController *alertController = [UIAlertController
                                                  alertControllerWithTitle:@"Success"
                                                  message:@"Growth Saved Successfully. "
                                                  preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction
                                       actionWithTitle:@"OK"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction *action)
                                       {
                                            if(![Utility isEmptyCheck:self->prvlocalImageName]){
                                                    [Utility removeImage:self->prvlocalImageName];
                                                }
                                           if ([self->achievementDelegate respondsToSelector:@selector(didAchievementsBackAction:)]) {
                                               [self->achievementDelegate didAchievementsBackAction:true];
                                           }
                                           [self.navigationController popViewControllerAnimated:YES];
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
    achievementDetails.attributedText = [Utility converHtmltotext:saveText];
    achievementDetails.accessibilityHint = saveText;
}
-(void)cancelNotes{
}
-(void)saveButtonDetails:(NSString *)saveText{
    isTitleSave = true;
    achievementTitle.text = saveText;
}

@end
