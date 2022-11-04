//
//  BucketListNewAddEditViewController.m
//  Squad
//
//  Created by AQB Solutions-Mac Mini 2 on 17/03/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import "BucketListNewAddEditViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "SongPlayListViewController.h"

#import <AVKit/AVKit.h> //song19
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>


@interface BucketListNewAddEditViewController (){
    IBOutlet UIScrollView *mainScroll;
    IBOutlet UIButton *viewReminder;
    IBOutlet UIButton *dateButton;

    IBOutlet UIButton *copyButton;
    IBOutlet UIButton *editButton;
    IBOutlet UIView *editCopyContainerViewEdit;
    IBOutlet UIButton *doneButton;
    IBOutlet UIButton *saveButton;
    IBOutlet UIButton *cancelButton;
    IBOutlet UIButton *deleteButton;
    IBOutlet UIView *saveCancelContainerView;
    IBOutlet UIButton *categoryButton;
    
    IBOutlet UIImageView *bucketImageView;
    IBOutlet UIView *setReminderContainerView;
    IBOutlet UIView *categoryContainerView;
    IBOutlet NSLayoutConstraint *categoryContainerViewHeightConstraint;
    
    IBOutlet UIButton *deleteImageButton;
    IBOutlet UIButton *addEditImage;
    IBOutlet UIView *imageUploadDeleteContainer;
    IBOutlet UITextView *bucketDetails;
    IBOutlet NSLayoutConstraint *bucketDetailsHeightConstraint;
    
    IBOutlet UITextView *bucketName;
    IBOutlet NSLayoutConstraint *bucketNameHeightConstraint;

    IBOutlet NSLayoutConstraint *imageViewHeightConstraint;   //ah 22.3

    IBOutlet UISwitch *reminderSwitch;
    IBOutletCollection(UIButton) NSArray *bucketstatesButton;
    IBOutlet UIButton *selectSongButton;
    IBOutlet UIView *songView;//song19
    IBOutlet UIButton *turnTohabit;
    IBOutlet UIButton *tickBtn;
    IBOutlet UIButton *progressButton;
    IBOutlet UIButton *completeButton;
    IBOutlet UIButton *hiddenButton;
    NSDate *selectedDate;

    UIView *contentView;
    UITextField *activeTextField;
    UITextView *activeTextView;
    UIToolbar *toolBar;
    UIImage *selectedImage;
    NSArray *categoryArray;
    NSDictionary *selectedCategoryDict;
    int apiCallCount;
    BOOL isCopy;
    BOOL isFirstTime;//song19
    AVAudioPlayer *player;

    NSMutableDictionary *savedReminderDict;     //ah ln
    BOOL isChanged;
    BOOL isFirstTimeReminderSet; //gami_badge_popup
    NSString *localImageName;
    NSString *prvlocalImageName;
    BOOL statusOfReminder;
    BOOL isExistingImageChange;
    
}
@end

@implementation BucketListNewAddEditViewController
@synthesize isEdit,bucketData;
#pragma mark - UIImagePickerControllerDelegate methods

/*
 Open PECropViewController automattically when image selected.
 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [Utility startFlashingbutton:saveButton];
    [Utility startFlashingbutton:doneButton];
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    bucketImageView.image = image;
    selectedImage=image;
    [addEditImage setTitle:@"CHANGE IMAGE" forState:UIControlStateNormal];
    deleteImageButton.hidden = false;
    isExistingImageChange = true;
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
    bucketImageView.image = croppedImage;
    selectedImage = croppedImage;
    [addEditImage setTitle:@"CHANGE IMAGE" forState:UIControlStateNormal];
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
        dispatch_async(dispatch_get_main_queue(),^ {
            self->isChanged = YES;
            [Utility startFlashingbutton:self->saveButton];
            [Utility startFlashingbutton:self->doneButton];
            
        });
    }];
}


#pragma mark - PrivateMethod

-(void)updateTextViewHeight:(UITextView *)text minHeight:(float)minHeight{

}
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
                                                                               if (![Utility isEmptyCheck:self->bucketData]) {
                                                                                   if (![Utility isEmptyCheck:[self->bucketData objectForKey:@"CategoryId"]]) {
                                                                                       NSDictionary *selectedDict = [Utility getDictByValue:self->categoryArray value:[self->bucketData objectForKey:@"CategoryId"] type:@"id"];
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
-(void)getBucketDataApiCall{
    if (Utility.reachable) {
        
        NSURLSession *achieveSession = [NSURLSession sharedSession];
        
        NSError *error;
        
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:[bucketData objectForKey:@"id"] forKey:@"bucketId"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
            self->apiCallCount++;
            self->contentView = [Utility activityIndicatorView:self];
        });
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetBucketSelectApiCall" append:@"" forAction:@"POST"];
        // GetGoalBucketList
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
                                                                           self->bucketData = [[responseDictionary objectForKey:@"Details"] mutableCopy];
                                                                           if (![Utility isEmptyCheck:self->bucketData]) {
                                                                               [self editButonPressed:0];

                                                                               if (self->_isFromNotificaton) {
                                                                                   self->reminderSwitch.on = true;
                                                                                   [self reminderSwitch:self->reminderSwitch];
                                                                                  }
                                                                           }else{
                                                                               self->bucketData = [[NSMutableDictionary alloc]init];
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
-(void)changeBucketStatusAPI_WebServiceCall:(int)index{
    if (Utility.reachable) {
        
        NSURLSession *achieveSession = [NSURLSession sharedSession];
        
        NSError *error;
        
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:[bucketData objectForKey:@"id"] forKey:@"bucketId"];
        if (index == 0) {
            [mainDict setObject:[NSNumber numberWithInt:BucketActive] forKey:@"BucketStatus"];
        }else if (index == 1){
            [mainDict setObject:[NSNumber numberWithInt:BucketCompleted] forKey:@"BucketStatus"];
        }else{
             [mainDict setObject:[NSNumber numberWithInt:BucketHidden] forKey:@"BucketStatus"];
        }
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
           self-> contentView = [Utility activityIndicatorView:self];
        });
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"ChangeBucketStatusAPI" append:@"" forAction:@"POST"];
        // GetGoalBucketList
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
                                                                           [[NSNotificationCenter defaultCenter]postNotificationName:@"IsBucketListReload" object:self userInfo:nil];
                                                                                    if (index == 0) {
                                                                                        self->progressButton.selected = true;
                                                                                        self->hiddenButton.selected = false;
                                                                                        self->completeButton.selected = false;
                                                                                     }else if (index == 1){
                                                                                         self->progressButton.selected = false;
                                                                                         self->hiddenButton.selected = false;
                                                                                         self->completeButton.selected = true;
                                                                                     }else if (index == 2){
                                                                                         self->progressButton.selected = false;
                                                                                         self->hiddenButton.selected = true;
                                                                                         self->completeButton.selected = false;
                                                                                         self->reminderSwitch.on = false;
                                                                                         [self->bucketData setValue:nil forKey:@"FrequencyId"];
                                                                                         [self saveDataInbackground];
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
        [mainDict setObject:[bucketData valueForKey:@"id"] forKey:@"BucketID"];
        
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"DeleteBucketApiCall" append:@"" forAction:@"POST"];
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
                                                                         [[NSNotificationCenter defaultCenter]postNotificationName:@"IsBucketListReload" object:self userInfo:nil];
                                                                         UIAlertController *alertController = [UIAlertController
                                                                                                               alertControllerWithTitle:@"Success"
                                                                                                               message:@"Deleted Successfully. "
                                                                                                               preferredStyle:UIAlertControllerStyleAlert];
                                                                         UIAlertAction *okAction = [UIAlertAction
                                                                                                    actionWithTitle:@"OK"
                                                                                                    style:UIAlertActionStyleDefault
                                                                                                    handler:^(UIAlertAction *action)
                                                                                                    {
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
-(void)saveDataInbackground{
    if (Utility.reachable) {
        if (![Utility isEmptyCheck:bucketName.text] && bucketName.text.length > 0 && ![bucketName.text isEqualToString:@"ADD BUCKET"]) {
            [bucketData setObject:bucketName.text forKey:@"Name"];
            
        }else{
            [Utility msg:@"Name is required " title:@"Error" controller:self haveToPop:NO];
            return;
        }
        if (![Utility isEmptyCheck:selectedCategoryDict]) {
            [bucketData setObject:selectedCategoryDict[@"id"] forKey:@"CategoryId"];
            
        }else{
            [Utility msg:@"Please Select Category " title:@"Error" controller:self haveToPop:NO];
            return;
        }
        if (![Utility isEmptyCheck:selectedDate]) {
            NSDateFormatter *dateFormatter = [NSDateFormatter new];
            [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
            [dateFormatter setDateFormat:@"yyyy-MM-dd'T'hh:mm:ss"];
            NSDate *dateFromCurrent = selectedDate;
//            if (isChanged) {
//                dateFromCurrent = selectedDate;
//            }else{
//                dateFromCurrent = [selectedDate dateByAddingYears:1];
//            }
            NSString *date = [dateFormatter stringFromDate:dateFromCurrent];

            [bucketData setObject:date forKey:@"CompletionDate"];
        }else{
            [Utility msg:@"Please select date." title:@"Warning !" controller:self haveToPop:NO];
            return;
        }
        if (![Utility isEmptyCheck:bucketDetails.text]) {
            [bucketData setObject:bucketDetails.text forKey:@"Description"];
        }
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
        if (bucketData[@"id"] == nil || isCopy) {
            [bucketData setObject:[NSNumber numberWithInteger:0] forKey:@"id"];
        }
        if (bucketData[@"CreatedBy"] == nil) {
            [bucketData setObject:[defaults valueForKey:@"UserID"] forKey:@"CreatedBy"];
        }
        
        [bucketData setObject:@"" forKey:@"UploadPictureImgBase64"];
        
        if(![Utility isEmptyCheck:localImageName]){
            [bucketData setObject:localImageName forKey:@"PictureDevicePath"];
        }else{
            [bucketData setObject:@"" forKey:@"PictureDevicePath"];
        }
        
        
        NSError *error;
        NSURLSession *loginSession = [NSURLSession sharedSession];

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
            NSMutableURLRequest *request = [Utility uploadImageWithFileName:@"property" withapi:@"AddUpdateBucketApiCallWithPhoto" append:@"" image:nil jsonString:jsonString];
            NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                             completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                                 dispatch_async(dispatch_get_main_queue(), ^{
                                                                     
                                                                     if(error == nil)
                                                                     {
                                                                         NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                         NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                         if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDictionary] && [[responseDictionary objectForKey:@"SuccessFlag"] boolValue]) {
                                                                            [[NSNotificationCenter defaultCenter]postNotificationName:@"IsBucketListReload" object:self userInfo:nil];

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
        [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
    }
    
}
-(void) saveDataMultiPart {
    if (Utility.reachable) {
        if (![Utility isEmptyCheck:bucketName.text] && bucketName.text.length > 0 && ![bucketName.text isEqualToString:@"ADD BUCKET"]) {
            [bucketData setObject:bucketName.text forKey:@"Name"];
            
        }else{
            [Utility msg:@"Name is required " title:@"Error" controller:self haveToPop:NO];
            return;
        }
        if (![Utility isEmptyCheck:selectedCategoryDict]) {
            [bucketData setObject:selectedCategoryDict[@"id"] forKey:@"CategoryId"];
            
        }else{
            [Utility msg:@"Please Select Category " title:@"Error" controller:self haveToPop:NO];
            return;
        }
        if (![Utility isEmptyCheck:selectedDate]) {
            NSDateFormatter *dateFormatter = [NSDateFormatter new];
            [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
            [dateFormatter setDateFormat:@"yyyy-MM-dd'T'hh:mm:ss"];
            NSDate *dateFromCurrent = selectedDate;
//            if (isChanged) {
//                dateFromCurrent = selectedDate;
//            }else{
//                dateFromCurrent = [selectedDate dateByAddingYears:1];
//            }
            NSString *date = [dateFormatter stringFromDate:dateFromCurrent];

            [bucketData setObject:date forKey:@"CompletionDate"];
        }else{
            [Utility msg:@"Please select date." title:@"Warning !" controller:self haveToPop:NO];
            return;
        }
        if (![Utility isEmptyCheck:bucketDetails.text]) {
            [bucketData setObject:bucketDetails.text forKey:@"Description"];
        }
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
        if (bucketData[@"id"] == nil || isCopy) {
            [bucketData setObject:[NSNumber numberWithInteger:0] forKey:@"id"];
        }
        if (bucketData[@"CreatedBy"] == nil) {
            [bucketData setObject:[defaults valueForKey:@"UserID"] forKey:@"CreatedBy"];
        }
        
        [bucketData setObject:@"" forKey:@"UploadPictureImgBase64"];
        
        if(![Utility isEmptyCheck:localImageName]){
            [bucketData setObject:localImageName forKey:@"PictureDevicePath"];
        }else{
            [bucketData setObject:@"" forKey:@"PictureDevicePath"];
        }
        
        
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
        if (![Utility isEmptyCheck:bucketName.text] && bucketName.text.length > 0 && ![bucketName.text isEqualToString:@"ADD BUCKET"]) {
            [bucketData setObject:bucketName.text forKey:@"Name"];
            
        }else{
            [Utility msg:@"Name is required " title:@"Error" controller:self haveToPop:NO];
            return;
        }
        if (![Utility isEmptyCheck:selectedCategoryDict]) {
            [bucketData setObject:selectedCategoryDict[@"id"] forKey:@"CategoryId"];
            
        }else{
            [Utility msg:@"Please Select Category " title:@"Error" controller:self haveToPop:NO];
            return;
        }
        if (![Utility isEmptyCheck:selectedDate]) {
            NSDateFormatter *dateFormatter = [NSDateFormatter new];
            [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
            [dateFormatter setDateFormat:@"yyyy-MM-dd'T'hh:mm:ss"];
            NSString *date = [dateFormatter stringFromDate:selectedDate];
            [bucketData setObject:date forKey:@"CompletionDate"];
        }else{
            [Utility msg:@"Please select date." title:@"Warning !" controller:self haveToPop:NO];
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
            self->contentView = [Utility activityIndicatorView:self];
        });
        if (![Utility isEmptyCheck:bucketDetails.text]) {
            [bucketData setObject:bucketDetails.text forKey:@"Description"];
        }
        
        NSURLSession *achieveSession = [NSURLSession sharedSession];
        
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
        if (bucketData[@"id"] == nil || isCopy) {
            [bucketData setObject:[NSNumber numberWithInteger:0] forKey:@"id"];
        }
        if (bucketData[@"CreatedBy"] == nil) {
            [bucketData setObject:[defaults valueForKey:@"UserID"] forKey:@"CreatedBy"];
        }
        
        if (![Utility isEmptyCheck:selectedImage]) {
            selectedImage =[Utility scaleImage:selectedImage width:selectedImage.size.width height:selectedImage.size.height];
            selectedImage = [UIImage imageWithData:UIImageJPEGRepresentation(selectedImage, 0.05)];

            NSString *imgBase64Str = [UIImagePNGRepresentation(selectedImage) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
            [bucketData setObject:imgBase64Str forKey:@"UploadPictureImgBase64"];
        }else{
            [bucketData setObject:@"" forKey:@"UploadPictureImgBase64"];
        }
        
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
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"AddUpdateBucketApiCallWithPhoto" append:@"" forAction:@"POST"];
        
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
                                                                           if (self->reminderSwitch.isOn && ![Utility isEmptyCheck:self->savedReminderDict] && [[savedReminderDict objectForKey:@"PushNotification"] boolValue]) {
                                                                               [self->bucketData setObject:[[responseDictionary objectForKey:@"Details"] objectForKey:@"id"] forKey:@"id"];
                                                                               
//                                                                               if (SYSTEM_VERSION_LESS_THAN(@"10")) {   //ah ln1
                                                                               [SetReminderViewController setOldLocalNotificationFromDictionary:self->savedReminderDict ExtraData:bucketData FromController:(NSString *)@"BucketList" Title:bucketName.text Type:@"BucketList" Id:[[bucketData objectForKey:@"id"] intValue]];
//                                                                               } else {
//                                                                                   [SetReminderViewController setLocalNotificationFromDictionary:savedReminderDict ExtraData:bucketData FromController:(NSString *)@"BucketList" Title:bucketName.text Type:@"BucketList" Id:[[bucketData objectForKey:@"id"] intValue]];    //ah ln
//                                                                               }
                                                                           }
                                                                           
                                                                           
                                                                           [self dismissViewControllerAnimated:YES completion:^{
                                                                               [Utility msg:@"Saved Successfully. " title:@"Success !" controller:self haveToPop:NO];

                                                                           }];
//                                                                           [player pause];
                                                                           
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
    //controller.keepingCropAspectRatio = YES;
    controller.cropAspectRatio = 1;
    controller.toolbarHidden = YES;
    
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
    if (![Utility isEmptyCheck:bucketData]) {
        NSString *createdDate = [bucketData objectForKey:@"CompletionDate"];
        if (createdDate.length >=19) {
            createdDate = [createdDate substringToIndex:19];
        }
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
        NSString *name = bucketData[@"Name"];
        bucketName.text = ![Utility isEmptyCheck:name] ? name : @"";
        bucketName.textColor = [UIColor darkGrayColor];
        if (bucketName.contentSize.height > 40) {
            NSLog(@"%f",bucketName.contentSize.height);
            bucketNameHeightConstraint.constant = bucketName.contentSize.height;
            [self.view setNeedsUpdateConstraints];
        }
        
        NSString *description = bucketData[@"Description"];
        bucketDetails.text = ![Utility isEmptyCheck:description] ? description : @"";
        if (bucketDetails.contentSize.height > 49) {
            bucketDetailsHeightConstraint.constant = bucketDetails.contentSize.height;
            [self.view setNeedsUpdateConstraints];
        }
        
        if(![Utility isEmptyCheck:[bucketData objectForKey:@"PictureDevicePath"]]){
            localImageName = [bucketData objectForKey:@"PictureDevicePath"];
            selectedImage = [Utility getImageFromDocumentDirectoryWithImageName:localImageName];
            
            if(selectedImage){
                CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
               CGFloat imageViewHeight = selectedImage.size.height/selectedImage.size.width * screenWidth;
               self->imageViewHeightConstraint.constant = imageViewHeight;
                bucketImageView.image = selectedImage;
                [addEditImage setTitle:@"CHANGE IMAGE" forState:UIControlStateNormal];
            }else if (![Utility isEmptyCheck:[bucketData objectForKey:@"Picture"]]) {
                NSString *imageUrlString =[bucketData objectForKey:@"Picture"];
                
                [bucketImageView sd_setImageWithURL:[NSURL URLWithString:[imageUrlString stringByAddingPercentEncodingWithAllowedCharacters:
                                                       [NSCharacterSet URLQueryAllowedCharacterSet]]]
                placeholderImage:[UIImage imageNamed:@"img_holder.png"]
                       options:SDWebImageScaleDownLargeImages completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                           dispatch_async(dispatch_get_main_queue(), ^{
                               if (image) {
                                   //ah 22.3
                                   CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
                                   CGFloat imageViewHeight = image.size.height/image.size.width * screenWidth;
                                   self->imageViewHeightConstraint.constant = imageViewHeight;
                                   self->selectedImage = image;
                                   self->bucketImageView.image = image;
                               }
                               else {
                                   self->selectedImage = nil;
                                   self->bucketImageView.image = [UIImage imageNamed:@"upload_image.png"];
                               }
                           });
                       }];
            }else{
                bucketImageView.image = [UIImage imageNamed:@"upload_image.png"];
                [addEditImage setTitle:@"UPLOAD" forState:UIControlStateNormal];
            }
            
            
        }else if (![Utility isEmptyCheck:[bucketData objectForKey:@"Picture"]]) {
            NSString *imageUrlString =[bucketData objectForKey:@"Picture"];
            
            [bucketImageView sd_setImageWithURL:[NSURL URLWithString:[imageUrlString stringByAddingPercentEncodingWithAllowedCharacters:
                                                   [NSCharacterSet URLQueryAllowedCharacterSet]]]
            placeholderImage:[UIImage imageNamed:@"img_holder.png"]
                   options:SDWebImageScaleDownLargeImages completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                       dispatch_async(dispatch_get_main_queue(), ^{
                        if (image) {
                               //ah 22.3
                               CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
                               CGFloat imageViewHeight = image.size.height/image.size.width * screenWidth;
                               self->imageViewHeightConstraint.constant = imageViewHeight;
                               self->selectedImage = image;
                               self->bucketImageView.image = image;
                           }
                           else {
                               self->selectedImage = nil;
                               self->bucketImageView.image = [UIImage imageNamed:@"upload_image.png"];
                           }
                       });
                   }];
        }else{
            localImageName = [Utility createImageFileNameFromTimeStamp];
            bucketImageView.image = [UIImage imageNamed:@"upload_image.png"];
            [addEditImage setTitle:@"UPLOAD" forState:UIControlStateNormal];
        }
        
        if (![Utility isEmptyCheck:[bucketData objectForKey:@"BucketStatus"]]) {
            NSLog(@"%@",[bucketData objectForKey:@"BucketStatus"]);
            int bucketStatusValue = [[bucketData objectForKey:@"BucketStatus"] intValue];
            if (bucketStatusValue == 0){
                progressButton.selected = false;
                hiddenButton.selected = true;
                completeButton.selected = false;
            }else if (bucketStatusValue == 1) {
                progressButton.selected = true;
                hiddenButton.selected = false;
                completeButton.selected = false;
            }else if (bucketStatusValue == 2){
                progressButton.selected = false;
                hiddenButton.selected = false;
                completeButton.selected = true;
            }
            
        }
        
       /* NSString *imageUrlString =[bucketData objectForKey:@"Picture"];
        if (![Utility isEmptyCheck:[bucketData objectForKey:@"Picture"]]) {
            imageUrlString = [imageUrlString stringByReplacingOccurrencesOfString:@"thumbnails/" withString:@""];
            NSURL *url = [NSURL URLWithString:imageUrlString];
            //[bucketImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"EXERCISE-picture-coming.jpg"] options:SDWebImageRefreshCached];
            bucketImageView.image = [UIImage imageNamed:@"upload_image.png"];
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
                                        imageViewHeightConstraint.constant = imageViewHeight;
                                        selectedImage = image;
                                        bucketImageView.image = image;
                                    }
                                    else {
                                        selectedImage = nil;
                                        bucketImageView.image = [UIImage imageNamed:@"upload_image.png"];
                                    }
                                }];
        }else {
            bucketImageView.image = [UIImage imageNamed:@"upload_image.png"];
            selectedImage = nil;
        }*/
        
        
        if ((![Utility isEmptyCheck:[bucketData objectForKey:@"PushNotification"]] && [[bucketData objectForKey:@"PushNotification"] boolValue]) || (![Utility isEmptyCheck:[bucketData objectForKey:@"Email"]] && [[bucketData objectForKey:@"Email"] boolValue])) {
            reminderSwitch.on = true;
            savedReminderDict = bucketData;  //ah ln
        }else{
            reminderSwitch.on = false;
        }
    }
    if (!isEdit){
        if (![Utility isEmptyCheck:bucketData]) {
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
        bucketName.editable = false;
        bucketDetails.editable = false;
        categoryButton.enabled = false;
        imageUploadDeleteContainer.hidden =true;
        //song19
        songView.hidden = YES;
        if (![Utility isEmptyCheck:[bucketData objectForKey:@"Song"]]) {
            //play song
            NSError *error;
            //            if ([[NSFileManager defaultManager] fileExistsAtPath:[_selectedGoalDict objectForKey:@"Song"]]) { @"%@*#*%@"
            NSArray *songArr = [[bucketData objectForKey:@"Song"] componentsSeparatedByString:@"*##*"];
            
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
        //Song19End

    }else{
        if (![Utility isEmptyCheck:bucketData]) {
            copyButton.hidden = false;
            editButton.hidden = true;
            
        }else{
            copyButton.hidden = true;
            editButton.hidden = true;
        }
        deleteButton.hidden = true;
        saveCancelContainerView.hidden = false;
        doneButton.hidden = false;
        setReminderContainerView.hidden = false;
        categoryContainerView.hidden = true;//false
        categoryContainerViewHeightConstraint.constant = 0;//40
        
        bucketName.editable = true;
        bucketDetails.editable = true;
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
    //if (editButton.hidden && copyButton.hidden) {
    if (editButton.hidden) {
        editCopyContainerViewEdit.hidden = true;
    }else{
        editCopyContainerViewEdit.hidden = false;
    }
    if (bucketName.contentSize.height > 40) {
        NSLog(@"%f",bucketName.contentSize.height);

        bucketNameHeightConstraint.constant = bucketName.contentSize.height;
        [self.view setNeedsUpdateConstraints];
    }
    if (bucketDetails.contentSize.height > 49) {
        bucketDetailsHeightConstraint.constant = bucketDetails.contentSize.height;
        [self.view setNeedsUpdateConstraints];
    }
    [self prepareReminderView];
}
-(void)prepareReminderView{
    if (reminderSwitch.on) {
        viewReminder.enabled = true;
        [viewReminder setTitle:@"View Reminder Settings" forState:UIControlStateNormal];
        [viewReminder setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];

    }else{
        [bucketData removeObjectForKey:@"FrequencyId"];
        viewReminder.enabled = false;
        [viewReminder setTitle:@"Reminder" forState:UIControlStateNormal];
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
                                        if(![Utility isEmptyCheck:self->prvlocalImageName] && ![Utility isEmptyCheck:self->localImageName] && ![self->prvlocalImageName isEqualToString:self->localImageName])
                                        {
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
- (IBAction)dateButonPressed:(UIButton *)sender {
    if (isEdit) {
        DatePickerViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DatePicker"];
        controller.modalPresentationStyle = UIModalPresentationCustom;
        controller.selectedDate = selectedDate;
        controller.datePickerMode = UIDatePickerModeDate;
        controller.delegate = self;
        [self presentViewController:controller animated:YES completion:nil];
    }
    
}
- (IBAction)selectSongButtonTapped:(id)sender {
    //    SongListViewController *songController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SongListView"];
    //    songController.songListDelegate = self;
    
    SongPlayListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PlayListView"];
    controller.isSelectMusic = YES;
    controller.delegate = self;
    [self presentViewController:controller animated:YES completion:nil];
}

- (IBAction)viewReminder:(UIButton *)sender {
    statusOfReminder = true;
    SetReminderViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SetReminder"];
    if ([bucketData objectForKey:@"FrequencyId"] != nil)
        controller.defaultSettingsDict = bucketData;
    controller.reminderDelegate = self;
    controller.view.backgroundColor = [UIColor clearColor];
    controller.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:controller animated:YES completion:nil];
    
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
    isChanged = true;
    [Utility startFlashingbutton:saveButton];

    if ([sender isOn]) {
        if ((![Utility isEmptyCheck:[bucketData objectForKey:@"PushNotification"]] && [[bucketData objectForKey:@"PushNotification"] boolValue]) || (![Utility isEmptyCheck:[bucketData objectForKey:@"Email"]] && [[bucketData objectForKey:@"Email"] boolValue])) {
                   statusOfReminder = true;
               }else{
                   statusOfReminder = false;
               }
        SetReminderViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SetReminder"];
        if ([bucketData objectForKey:@"FrequencyId"] != nil)
            controller.defaultSettingsDict = bucketData;
            controller.reminderDelegate = self;
        if (isFirstTimeReminderSet) {
            controller.isFirstTime = isFirstTimeReminderSet;
            isFirstTimeReminderSet = false;
        }
        controller.view.backgroundColor = [UIColor clearColor];
        controller.modalPresentationStyle = UIModalPresentationCustom;
        [self presentViewController:controller animated:YES completion:nil];
    } else {

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
                                    if ([self->bucketData objectForKey:@"FrequencyId"] != nil)
                                            controller.defaultSettingsDict = self->bucketData;
                                            controller.reminderDelegate = self;
                                        if (self->isFirstTimeReminderSet) {
                                            controller.isFirstTime = self->isFirstTimeReminderSet;
                                            self->isFirstTimeReminderSet = false;
                                   }
                                   controller.view.backgroundColor = [UIColor clearColor];
                                   controller.modalPresentationStyle = UIModalPresentationCustom;
                                   [self presentViewController:controller animated:YES completion:nil];
                                }];
           UIAlertAction* turnOffReminder = [UIAlertAction
                                    actionWithTitle:@"TURN OFF REMINDER"
                                    style:UIAlertActionStyleCancel
                                    handler:^(UIAlertAction * action)
                                    {
                                        [self->bucketData removeObjectForKey:@"FrequencyId"];
                                        [self->bucketData setObject:[NSNumber numberWithBool:false]  forKey:@"PushNotification"];
                                        [self->bucketData setObject:[NSNumber numberWithBool:false] forKey:@"Email"];
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
                             self->bucketImageView.image = [UIImage imageNamed:@"upload_image.png"];
                             [self->bucketData removeObjectForKey:@"UploadPictureImgFileName"];
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
- (IBAction)copyButtonPressed:(id)sender {
    isCopy = true;
    copyButton.hidden = true;
    bucketName.text = [@"COPY OF : " stringByAppendingString:bucketName.text];
    if (editButton.hidden && copyButton.hidden) {
        editCopyContainerViewEdit.hidden = true;
    }else{
        editCopyContainerViewEdit.hidden = false;
    }
    if (bucketName.contentSize.height > 40) {
        bucketNameHeightConstraint.constant = bucketName.contentSize.height;
        [self.view setNeedsUpdateConstraints];
    }
    if (bucketDetails.contentSize.height > 49) {
        bucketDetailsHeightConstraint.constant = bucketDetails.contentSize.height;
        [self.view setNeedsUpdateConstraints];
    }
}

- (IBAction)editButonPressed:(UIButton *)sender {
    if (bucketData) {
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
            if(![Utility isEmptyCheck:self->bucketData]){
                self->isEdit= false;
                if (self->isCopy) {
                    self->isCopy = false;
                    self->copyButton.hidden = false;
                    NSString *name = self->bucketData[@"Name"];
                    self->bucketName.text = ![Utility isEmptyCheck:name] ? name : @"";
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
                                  message:@"Are you sure you want to delete this gratitude??"
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"Confirm"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [self delete];
                             
                             //                             if (SYSTEM_VERSION_LESS_THAN(@"10")) {   //ah ln1
                             NSArray *requests = [[UIApplication sharedApplication] scheduledLocalNotifications];
                             for (UILocalNotification *req in requests) {
                                 NSString *pushTo = [req.userInfo objectForKey:@"pushTo"];
                                 if ([pushTo caseInsensitiveCompare:@"BucketList"] == NSOrderedSame) {
                                     int bucketRemID = [[req.userInfo objectForKey:@"ID"] intValue];
                                     if (bucketRemID == [[self->bucketData objectForKey:@"id"] intValue]) {
                                         [[UIApplication sharedApplication] cancelLocalNotification:req];
                                     }
                                 }
                             }
                             //                             } else {
                             //                                 NSMutableArray *removeIDs = [[NSMutableArray alloc] init];
                             //
                             //                                 UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
                             //                                 [center getPendingNotificationRequestsWithCompletionHandler:^(NSArray<UNNotificationRequest *> * _Nonnull requests) {
                             //                                     for (UNNotificationRequest *req in requests) {
                             //                                         NSString *remId = req.identifier;
                             //                                         NSArray *arr = [remId componentsSeparatedByString:@"_"];
                             //                                         if ([[arr objectAtIndex:1] caseInsensitiveCompare:@"BucketList"] == NSOrderedSame) {
                             //                                             int bucketRemID = [[arr objectAtIndex:2] intValue];
                             //                                             if (bucketRemID == [[bucketData objectForKey:@"id"] intValue]) {
                             //                                                 [removeIDs addObject:remId];
                             //                                                 [center removePendingNotificationRequestsWithIdentifiers:removeIDs];
                             //                                             }
                             //                                         }
                             //                                     }
                             //                                 }];
                             //                             }
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
                [self.navigationController popToRootViewControllerAnimated:YES];
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
    [player pause];
    if (isEdit) {
        [self shouldPopOnBackButtonWithResponse:^(BOOL shouldPop) {
            if (shouldPop) {
                if (![Utility isEmptyCheck:self->bucketData]) {
//                    isEdit = NO;
//                    isChanged = NO;
//                    [Utility stopFlashingbutton:saveButton];
//                    [Utility stopFlashingbutton:doneButton];
//                    [self prepareView];
                      [self.navigationController popViewControllerAnimated:NO];
                }else {
//                    [self dismissViewControllerAnimated:YES completion:nil];
                    [self.navigationController popViewControllerAnimated:NO];

                }
                
            }
        }];
    }else {
//        [self dismissViewControllerAnimated:YES completion:nil];
        [self.navigationController popViewControllerAnimated:NO];
    }
}
-(IBAction)changeStatusButtonPressed:(UIButton*)sender{
    
    [self changeBucketStatusAPI_WebServiceCall:(int)sender.tag];
}
#pragma mark - ViewLifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"CurrentFile Name: %@",[Utility createImageFileNameFromTimeStamp]);
    localImageName = [Utility createImageFileNameFromTimeStamp];
    apiCallCount = 0;
    isFirstTime = YES; //song19
    isChanged = NO;
    isFirstTimeReminderSet = true; //gami_badge_popup
    saveButton.layer.cornerRadius = 15;
    saveButton.layer.masksToBounds = YES;
    cancelButton.layer.cornerRadius = 15;
    cancelButton.layer.masksToBounds = YES;
//    cancelButton.layer.borderColor = squadMainColor.CGColor;
//    cancelButton.layer.borderWidth = 1;
    turnTohabit.layer.borderColor = squadMainColor.CGColor;
    turnTohabit.layer.borderWidth = 1;
    
    turnTohabit.layer.cornerRadius = 15;
    turnTohabit.layer.masksToBounds = YES;
    tickBtn.layer.cornerRadius = 15;
    tickBtn.layer.masksToBounds = YES;
    
    [Utility stopFlashingbutton:saveButton];
    [Utility stopFlashingbutton:doneButton];
    toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)]; //toolbar is uitoolbar object
    toolBar.barStyle = UIBarStyleBlackOpaque;
    toolBar.translucent = YES;
    UIBarButtonItem *btnDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(btnClickedDone:)];
    [toolBar setItems:[NSArray arrayWithObject:btnDone]];
    [self registerForKeyboardNotifications];
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    addEditImage.layer.cornerRadius = 15;
    addEditImage.layer.masksToBounds = YES;
    addEditImage.layer.borderColor = squadMainColor.CGColor;
    addEditImage.layer.borderWidth = 1;
    
    if (isFirstTime) {
        isFirstTime = NO;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            if (![Utility isEmptyCheck:self->bucketData]) {
                [self getBucketDataApiCall];
            }else{
                self->bucketData = [[NSMutableDictionary alloc]init];
            }
            [self getCategory];
        });
    }
    
}
- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:YES];
    [self.view endEditing:YES];
    [player pause];
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
    activeTextField = textField;
    activeTextView = nil;
    isChanged = YES;
    [Utility startFlashingbutton:saveButton];
    [Utility startFlashingbutton:doneButton];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    activeTextField = nil;
}
#pragma mark - End

#pragma mark - textView Delegate
- (BOOL)textView:(UITextView *)txtView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([txtView isEqual:bucketName]) {
//        if (txtView.contentSize.height > 40) {
            bucketNameHeightConstraint.constant =txtView.contentSize.height;
//
        
//    }
        
    }else if([txtView isEqual:bucketDetails]){
        if (txtView.contentSize.height > 49) {
            bucketDetailsHeightConstraint.constant =txtView.contentSize.height;
        }
    }
    [self.view layoutIfNeeded];
    [self.view setNeedsUpdateConstraints];
    return YES;
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    [textView setInputAccessoryView:toolBar];
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    activeTextView = textView;
    activeTextField = nil;
    if([bucketName.text caseInsensitiveCompare:@"ADD BUCKET"] == NSOrderedSame){
        bucketName.text = @"";
        bucketName.textColor = [UIColor darkGrayColor];
    }
    isChanged = YES;
    [Utility startFlashingbutton:saveButton];
    [Utility startFlashingbutton:doneButton];
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    activeTextView = nil;
    if(bucketName.text.length == 0){
        bucketName.textColor = [UIColor lightGrayColor];
        bucketName.text = @"ADD BUCKET";
        [bucketName resignFirstResponder];
    }

}


#pragma mark - End

#pragma mark - SongListDelegate

- (void) getSelectedSongName:(NSString *)name Url:(NSString *)songUrlStr {
    NSLog(@"su %@",songUrlStr);
    isChanged = YES;
    [Utility startFlashingbutton:saveButton];
    [Utility startFlashingbutton:doneButton];
    [selectSongButton setAccessibilityHint:songUrlStr];
    [selectSongButton setTitle:name forState:UIControlStateNormal];
    NSString *saveSongDataStr = [NSString stringWithFormat:@"%@*##*%@",songUrlStr,name];
    [bucketData setObject:saveSongDataStr forKey:@"Song"];      //ah song
    
}

#pragma mark -End

#pragma mark - Reminder Delegate

-(void) reminderSettingsValue:(NSMutableDictionary *)reminderDict {
    NSLog(@"rem %@",reminderDict);
    isChanged = YES;
    [Utility startFlashingbutton:saveButton];
    [Utility startFlashingbutton:doneButton];
    savedReminderDict = reminderDict;   //ah ln
    [bucketData addEntriesFromDictionary:reminderDict];
    if ((![Utility isEmptyCheck:[bucketData objectForKey:@"PushNotification"]] && [[bucketData objectForKey:@"PushNotification"] boolValue]) || (![Utility isEmptyCheck:[bucketData objectForKey:@"Email"]] && [[bucketData objectForKey:@"Email"] boolValue])) {
        reminderSwitch.on = true;
    }else{
        reminderSwitch.on = false;
    }
    [self prepareReminderView];
}
-(void) cancelReminder {
    isChanged = NO;
//    [Utility stopFlashingbutton:saveButton];
    reminderSwitch.on = statusOfReminder;
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
    NSLog(@"ty %@ \ndata %@",type,selectedData);
    isChanged = YES;
    [Utility startFlashingbutton:saveButton];
    [Utility startFlashingbutton:doneButton];
    if ([type caseInsensitiveCompare:@"Category"] == NSOrderedSame) {
        selectedCategoryDict =selectedData;
        [categoryButton setTitle:[selectedData objectForKey:@"CategoryName"] forState:UIControlStateNormal];
        [bucketData setObject:[selectedData objectForKey:@"id"] forKey:@"CategoryId"];
    }
}

#pragma mark - End

#pragma  mark -DatePickerViewControllerDelegate
-(void)didSelectDate:(NSDate *)date{
    NSLog(@"%@",date);
    if (date) {
        isChanged = YES;
        [Utility startFlashingbutton:saveButton];
        [Utility startFlashingbutton:doneButton];
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

#pragma mark progressbar delegate

- (void) completedWithResponse:(NSString *)responseString responseDict:(NSDictionary *)responseDict{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"SuccessFlag"] boolValue]) {
            self->isChanged = NO;
            [Utility stopFlashingbutton:self->saveButton];
            [Utility stopFlashingbutton:self->doneButton];
            //gami_badge_popup
            if (self->_isNewBucket) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateBadgePoint" object:self];//gami_badge_popup
            }
            //gami_badge_popup
            
            //ah ln
            if (self->reminderSwitch.isOn && ![Utility isEmptyCheck:self->savedReminderDict] && [[self->savedReminderDict objectForKey:@"PushNotification"] boolValue]) {
                [self->bucketData setObject:[[responseDict objectForKey:@"Details"] objectForKey:@"id"] forKey:@"id"];
                self->bucketData  = [[Utility replaceDictionaryNullValue:self->bucketData] mutableCopy];

                //                                                                               if (SYSTEM_VERSION_LESS_THAN(@"10")) {   //ah ln1
                [SetReminderViewController setOldLocalNotificationFromDictionary:self->savedReminderDict ExtraData:self->bucketData FromController:(NSString *)@"BucketList" Title:self->bucketName.text Type:@"BucketList" Id:[[self->bucketData objectForKey:@"id"] intValue]];
            }
            [Utility saveImageDetails:self->localImageName imagetype:BucketList Itemid:[[[responseDict objectForKey:@"Details"] objectForKey:@"id"]intValue] existingImageChange:self->isExistingImageChange selectedImage:self->selectedImage];

            UIAlertController *alertController = [UIAlertController
                                                  alertControllerWithTitle:@"Success"
                                                  message:@"Saved Successfully. "
                                                  preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction
                                       actionWithTitle:@"OK"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction *action)
                                       {
                                            if(![Utility isEmptyCheck:self->prvlocalImageName]){
                                                [Utility removeImage:self->prvlocalImageName];
                                            }
                                            [[NSNotificationCenter defaultCenter]postNotificationName:@"IsBucketListReload" object:self userInfo:nil];
                                             NSArray *arr = [self.navigationController viewControllers];
                                            BOOL isControllerHave = false;

                                            for (int i = 0 ; i<arr.count; i++) {
                                                   if ([arr[i] isKindOfClass:[BucketListNewViewController class]]) {
                                                       isControllerHave =  true;
                                                       [self.navigationController popToViewController:arr[i] animated:NO];
                                                   }
                                               }
                                            if (!isControllerHave) {
                                                BucketListNewViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"BucketListNew"];
                                                [self.navigationController pushViewController:controller animated:NO];
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

@end
