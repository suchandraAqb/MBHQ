//
//  AddImageViewController.m
//  Squad
//
//  Created by AQB Mac 4 on 15/03/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import "AddImageViewController.h"
#import "Utility.h"
#import "ProgressBarViewController.h"

@interface AddImageViewController ()
{
    IBOutlet UIButton *datePickerButton;
    IBOutlet UIImageView *bodyimage;
    IBOutlet UITextView *noteTextView;
    IBOutlet UIScrollView *mainScroll;
    UIImage *galaryimage;
    BOOL sizeBeyondLimit;
    UITextField *activeTextField;
    UITextView *activeTextView;
    DatePickerViewController *customDatepicker;
    NSDate *selectedDate;
    UIView *contentView;
    NSMutableDictionary *tempDict;
    NSDictionary *bodyCatagoryType;
    NSString *currentDate;
    NSMutableArray *compareDateArray;
    
}
@end

@implementation AddImageViewController
@synthesize bodyCatagorystring,addPhotoDelegate;

#pragma mark - IBAction

-(IBAction)datePickerButtonPressed:(id)sender{
    DatePickerViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DatePicker"];
    controller.modalPresentationStyle = UIModalPresentationCustom;
    controller.selectedDate = selectedDate;
    controller.datePickerMode = UIDatePickerModeDate;
    controller.delegate = self;
    [self presentViewController:controller animated:YES completion:nil];
}
-(IBAction)cancelButtonPressed:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(IBAction)browseButtonPressed:(id)sender{
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    controller.delegate = self;
    controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:controller animated:YES completion:NULL];
}
-(IBAction)clickPhotoBittonPressed:(id)sender{
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]){
        // Has camera
        
        //ah newt
        CameraViewController *cameraViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Camera"];
        cameraViewController.cameraDelegate = self;
        [self presentViewController:cameraViewController animated:YES completion:nil];
        
        
        //        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        //        controller.delegate = self;
        //        controller.sourceType = UIImagePickerControllerSourceTypeCamera;
        //        [self presentViewController:controller animated:YES completion:NULL];
    }else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Camera not available" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}
-(IBAction)uploadButtonPressed:(id)sender{
    if (sizeBeyondLimit) {
        [Utility msg:@"Image size must be less than 5 MB" title:@"Alert" controller:self haveToPop:NO];
    }else{
        if ([self formValidation]) {
            //[self addUserBodyPhotoApiCall];
            [self addUserBodyPhotoMultipartApiCall];
        }
    }
}
- (IBAction)openEditor:(id)sender
{
    PECropViewController *controller = [[PECropViewController alloc] init];
    controller.delegate = self;
    controller.image = bodyimage.image;
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
#pragma mark - End

#pragma mark - Private Function

-(UIImage *)imageCompression:(UIImage *)image{
    UIImage *compressedImage;
    NSData * imagedata =  UIImageJPEGRepresentation(image, 0.8);
    NSUInteger imageSize = imagedata.length;
    compressedImage = [UIImage imageWithData:imagedata];
    float sizeInMB=(float)imageSize/1024/1024;
    if(sizeInMB>5){
        sizeBeyondLimit=YES;
    }
    // NSLog(@"SIZE OF IMAGE: %.2f Mb, %.2f KB %.2f B", (float)imageSize/1024/1024,(float)imageSize/1024,(float)imageSize);
    return compressedImage;
}

-(void)doneButton{
    [noteTextView resignFirstResponder];
}

-(BOOL)formValidation{
    BOOL isValidated = NO;
    NSString *datePickerButtonString= datePickerButton.titleLabel.text;
    NSString *currentDateStr = @"";
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    currentDateStr = [dateFormat stringFromDate:selectedDate];
    
    if (datePickerButtonString.length < 1){
        [Utility msg:@"Please select date." title:@"Oops!" controller:self haveToPop:NO];
        return isValidated;
    } else if ([Utility isEmptyCheck:galaryimage]){
        [Utility msg:@"Choose an image from gallery or camera." title:@"Oops!" controller:self haveToPop:NO];
        return isValidated;
    }/*else if (![Utility isEmptyCheck:compareDateArray] && [compareDateArray containsObject:currentDateStr]){
        [self alertWithTitle:@"Alert!" message:@"Photo for this date already exists. Reuploading for same date will replace existing photo. Click 'OK' to upload."];
        return isValidated;
    }*/
    return YES;
}

-(void)alertWithTitle:(NSString *)title message:(NSString *)message
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              [self addUserBodyPhotoMultipartApiCall];
                                                          }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"CANCEL"
                                                            style:UIAlertActionStyleCancel
                                                          handler:^(UIAlertAction * action) {
                                                              
                                                          }];
    
    [alert addAction:defaultAction];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)createCompareDateArray{
    
    if(![Utility isEmptyCheck:_existingPhotosArray]){
        
        NSArray *dateTakenArr = [_existingPhotosArray valueForKey:@"DateTaken"];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
        if(![Utility isEmptyCheck:dateTakenArr]){
            compareDateArray = [NSMutableArray new];
            for(NSString *dateStr in dateTakenArr){
                NSDate *newDate = [dateFormat dateFromString:dateStr];
                [dateFormat setDateFormat:@"yyyy-MM-dd"];
                NSString *newdateStr = [dateFormat stringFromDate:newDate];
                if(newdateStr)[compareDateArray addObject:newdateStr];
                [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
            }
            
        }
        
    }
    
}
#pragma mark - API Call

-(void)addUserBodyPhotoMultipartApiCall{
    if (Utility.reachable) {
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:[defaults valueForKey:@"UserID"] forKey:@"UserID"];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:currentDate forKey:@"DateTaken"];
        if (![Utility isEmptyCheck:noteTextView.text]) {
            [mainDict setObject:noteTextView.text forKey:@"Notes"];
        }else{
            [mainDict setObject:@"" forKey:@"Notes"];
        }
        [mainDict setObject:[defaults valueForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        
        
        
        [mainDict setObject:[bodyCatagoryType objectForKey:bodyCatagorystring] forKey:@"Pose"];
        
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        ProgressBarViewController *controller=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ProgressBar"];
        controller.delegate=self;
        controller.apiName=@"AddNewPhotos";
        controller.appendString=@"";
        controller.jsonString=jsonString;
        controller.chosenImage=bodyimage.image;
        // controller.modalPresentationStyle = UIModalPresentationCustom;
        [self presentViewController:controller animated:YES completion:nil];
    }else{
        [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
    }
}



-(void)addUserBodyPhotoApiCall{
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (contentView) {
                [contentView removeFromSuperview];
            }
            contentView = [Utility activityIndicatorView:self];
        });
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:[defaults valueForKey:@"UserID"] forKey:@"UserID"];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:currentDate forKey:@"DateTaken"];
        if (![Utility isEmptyCheck:noteTextView.text]) {
            [mainDict setObject:noteTextView.text forKey:@"Notes"];
        }else{
            [mainDict setObject:@"" forKey:@"Notes"];
        }
        [mainDict setObject:[defaults valueForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        
        if (![Utility isEmptyCheck:galaryimage]) {
            NSData *dataImage = [[NSData alloc] init];
            dataImage = UIImagePNGRepresentation(bodyimage.image);
            NSString *stringImage = [dataImage base64EncodedStringWithOptions:0];
            [mainDict setObject:stringImage forKey:@"PhotoData"];
        }
        
        [mainDict setObject:[bodyCatagoryType objectForKey:bodyCatagorystring] forKey:@"Pose"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"AddUpdatePhotos" append:@"" forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 if (contentView) {
                                                                     [contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDictionary] && [[responseDictionary objectForKey:@"Success"] boolValue]) {
                                                                         
                                                                         
                                                                         if([addPhotoDelegate respondsToSelector:@selector(didPhotoAdded:)]){
                                                                             [addPhotoDelegate didPhotoAdded:YES];
                                                                         }
                                                                         [self dismissViewControllerAnimated:YES completion:^{
                                                                             [Utility msg:@"Image saved Successfully" title:@"Alert" controller:self haveToPop:NO];
                                                                         }];
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









#pragma mark - End

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    selectedDate = nil;
    [self registerForKeyboardNotifications];
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0,self.view.frame.size.width, 50)];
    numberToolbar.translucent=NO;
    numberToolbar.barTintColor=[Utility colorWithHexString:@"f427ab"];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.tintColor=[UIColor whiteColor];
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone  target:self action:@selector(doneButton)],nil];
    [numberToolbar sizeToFit];
    [noteTextView setInputAccessoryView:numberToolbar];
    [datePickerButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 0.0)];
    
    bodyCatagoryType = @{
                         @"Front":@1,
                         @"Side":@2,
                         @"Back":@3,
                         @"Final":@5
                         };
    [self createCompareDateArray];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

#pragma mark - End

#pragma mark - Memory Warning

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - End

#pragma mark - CameraDelegate
//ah newt

-(void) didFinishedTakingPhoto:(UIImage *)capturedImage {
    UIImage *image = capturedImage;
    image =[Utility scaleImage:image width:image.size.width height:image.size.height];
    image = [UIImage imageWithData:UIImageJPEGRepresentation(image, 0.3)];
    
    galaryimage = [self imageCompression:image];
    bodyimage.image = galaryimage;
    
    [self openEditor:nil];
}


#pragma mark - UIImagePickerControllerDelegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    //ah 21.3
    image =[Utility scaleImage:image width:image.size.width height:image.size.height];
    image = [UIImage imageWithData:UIImageJPEGRepresentation(image, 0.3)];
    
    //ah 22.3
    galaryimage = [self imageCompression:image];
    bodyimage.image = galaryimage;
    
    [picker dismissViewControllerAnimated:YES completion:^{
        [self openEditor:nil];
        
        //        [self writeImageInDocumentsDirectory: galaryimage];
    }];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - PECropViewControllerDelegate methods

- (void)cropViewController:(PECropViewController *)controller didFinishCroppingImage:(UIImage *)croppedImage transform:(CGAffineTransform)transform cropRect:(CGRect)cropRect
{
    [controller dismissViewControllerAnimated:YES completion:NULL];
    //    userImageView.image = croppedImage;
    //    UIImage *image=[self scaleImage:croppedImage];
    bodyimage.image = croppedImage;
    galaryimage = croppedImage;
    
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
    
    [controller dismissViewControllerAnimated:YES completion:NULL];
}
#pragma mark - TextView Delegate

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
    mainScroll.contentInset = contentInsets;
    mainScroll.scrollIndicatorInsets = contentInsets;
    
    CGRect aRect = mainScroll.frame;
    float x;
    if (activeTextView==nil) {
        x=aRect.size.height-activeTextField.frame.origin.y-activeTextField.frame.size.height;
        aRect.size.height -= kbSize.height;
        if (x < kbSize.height) {
            CGPoint scrollPoint = CGPointMake(0.0, kbSize.height+5-x);
            [mainScroll setContentOffset:scrollPoint animated:YES];
        }
    }
    else{
        x=aRect.size.height-activeTextView.frame.origin.y-activeTextView.frame.size.height;
        aRect.size.height -= kbSize.height;
        if (x < kbSize.height) {
            CGPoint scrollPoint = CGPointMake(0.0, kbSize.height+5-x);
            NSLog(@"x-%f y-%f",scrollPoint.x,scrollPoint.y);
            [mainScroll setContentOffset:scrollPoint animated:YES];
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

- (void)textViewDidBeginEditing:(UITextView *)textView{
    activeTextView=textView;
    activeTextField=nil;
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    activeTextView=nil;
}

#pragma mark - End

#pragma  mark -DatePickerViewControllerDelegate

-(void)didSelectDate:(NSDate *)date{
    NSLog(@"%@",date);
    if (date) {
        static NSDateFormatter *dateFormatter;
        dateFormatter = [NSDateFormatter new];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
        selectedDate = date;
        [dateFormatter setDateFormat:@"dd-MMM-yyyy"];
        NSString *dateString = [dateFormatter stringFromDate:date];
        [datePickerButton setTitle:dateString forState:UIControlStateNormal];
        
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
        currentDate = [dateFormatter stringFromDate:selectedDate];
    }
}
#pragma  mark -End




//chayan 16/10/2017
#pragma mark progressbar delegate

- (void) completedWithResponse:(NSString *)responseString responseDict:(NSDictionary *)responseDict{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"] boolValue]) {
           
               [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateBadgePoint" object:self];//gami_badge_popup
            
            [self dismissViewControllerAnimated:YES completion:^{
                if([addPhotoDelegate respondsToSelector:@selector(didPhotoAdded:)]){
                    [addPhotoDelegate didPhotoAdded:YES];
                }
//                [self->_addPhotoDelegate didPhotoAdded:YES];
            }];
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








