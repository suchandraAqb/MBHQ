//
//  CreateForumViewController.m
//  Squad
//
//  Created by MAC 6- AQB SOLUTIONS on 25/09/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import "CreateForumViewController.h"
#import "MasterMenuViewController.h"
#import "DropdownViewController.h"
#import "ProgressBarViewController.h"



@interface CreateForumViewController (){
    
    IBOutlet UITextField *forumNameTextField;
    IBOutlet UITextField *forumOverviewTextField;
    IBOutlet UITextView *forumRulesTextView;
    IBOutlet UITextView *forumDescriptionTextView;
    IBOutlet UILabel *chosenImageNameLabel;
    
    IBOutlet UIButton *selectTagButton;
    
    IBOutlet UIButton *chooseFileButton;
    IBOutlet UIScrollView *mainScroll;
    
    UIToolbar* numberToolbar;
    
    UITextField *activeTextField;
    UITextView *activeTextView;
    
    UIView *contentView;
    NSArray *tagArray;
    
    UIImage *chosenImage;
    
    
    int apiCount;
    
    
    
    
}

@end

@implementation CreateForumViewController


#pragma mark View Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone  target:self action:@selector(doneWithFirstResponder)],nil];
    [numberToolbar sizeToFit];
    forumNameTextField.inputAccessoryView = numberToolbar;
    forumOverviewTextField.inputAccessoryView = numberToolbar;
    forumRulesTextView.inputAccessoryView = numberToolbar;
    forumDescriptionTextView.inputAccessoryView = numberToolbar;
    
    [self registerForKeyboardNotifications];
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    chooseFileButton.layer.cornerRadius = 12;
    chooseFileButton.clipsToBounds = true;
    
    apiCount= 0;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self getEventTagListApiCall];
        
    });
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma Mark End


#pragma mark IBActions

- (IBAction)menuTapped:(id)sender {
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
    [self.slidingViewController resetTopViewAnimated:YES];
}

- (IBAction)logoTapped:(id)sender {
    [self.navigationController  popToRootViewControllerAnimated:YES];
}


-(IBAction)selectTagButtonTapped:(UIButton *)sender{
    DropdownViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Dropdown"];
    controller.modalPresentationStyle = UIModalPresentationCustom;
    controller.dropdownDataArray = tagArray;
    //    controller.selectedIndex = selectedTagIndex;
    controller.delegate = self;
    controller.multiSelect=true;
    controller.mainKey=@"Description";
    // controller.selectedIndex=-1;
    NSMutableArray *array = [[NSMutableArray alloc]init];
    if ([sender.titleLabel.text caseInsensitiveCompare:@"Select one or more tags.."] != NSOrderedSame) {
        NSArray *titleArray = [sender.titleLabel.text componentsSeparatedByString:@", "];
        for (int i =0;i<titleArray.count;i++) {
            NSString *title = [titleArray objectAtIndex:i];
            for (int j = 0; j < tagArray.count; j++) {
                NSDictionary *dict = [tagArray objectAtIndex:j];
                if ([[dict objectForKey:@"Description"] caseInsensitiveCompare:title] == NSOrderedSame) {
                    [array addObject:[NSNumber numberWithInteger:j]];
                }
            }
            
        }
        controller.selectedIndexes=array;
        NSLog(@"\narray:\n %@",array);
    }
    
    [self presentViewController:controller animated:YES completion:nil];
    
}

- (IBAction)chooseFileButtonTapped:(id)sender {
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

- (IBAction)requestForForumButtonTapped:(id)sender {
    if (![Utility isEmptyCheck:forumNameTextField.text]) {
        [self addNewForumApiCallWithImageUpload];
    }
    else{
        [Utility msg:@"Forum name cannot be empty!!" title:@"Oops! " controller:self haveToPop:NO];
    }
}


- (IBAction)openEditor:(id)sender
{
    PECropViewController *controller = [[PECropViewController alloc] init];
    controller.delegate = self;
    controller.image = chosenImage;
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


#pragma Mark End


#pragma mark - Private Methods

-(void)doneWithFirstResponder{
    [self.view endEditing:YES];
}

-(void)showCamera{
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    controller.delegate = self;
    controller.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:controller animated:YES completion:NULL];
}

-(void)openPhotoAlbum{
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    controller.delegate = self;
    controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:controller animated:YES completion:NULL];
}
#pragma Mark End

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
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    mainScroll.contentInset = contentInsets;
    mainScroll.scrollIndicatorInsets = contentInsets;
    CGRect aRect = mainScroll.frame;
    float x;
    if (activeTextField !=nil) {
        //        x=aRect.size.height-activeTextField.frame.origin.y-activeTextField.frame.size.height;
        //        aRect.size.height -= kbSize.height;
        //        if (x < kbSize.height) {
        //            CGPoint scrollPoint = CGPointMake(0.0, kbSize.height+5-x);
        //            [mainScroll setContentOffset:scrollPoint animated:YES];
        //        }
    } else if (activeTextView !=nil) {
        x=aRect.size.height-activeTextView.superview.superview.frame.origin.y-activeTextView.frame.size.height;
        aRect.size.height -= kbSize.height;
        if (x < kbSize.height) {
            CGPoint scrollPoint = CGPointMake(0.0, kbSize.height+5-x);
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

#pragma mark - textField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [activeTextView resignFirstResponder];
    activeTextField = textField;
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    activeTextField = nil;
    [textField resignFirstResponder];
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    
    
    if(range.length + range.location > textField.text.length)
    {
        return NO;
    }
    if (activeTextField==forumOverviewTextField) {
        
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return newLength <= 80;
    }
    else
        return YES;
}
#pragma Mark End

#pragma mark - textView Delegate
- (void)textViewDidBeginEditing:(UITextView *)textView{
    [activeTextField resignFirstResponder];
    activeTextView=textView;
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    activeTextView=nil;
    [textView resignFirstResponder];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if (activeTextView==forumDescriptionTextView) {
        return textView.text.length + (text.length - range.length) <= 250;
        
    }
    return YES;
}
#pragma Mark End

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
    NSURL *imagePath = [info objectForKey:@"UIImagePickerControllerReferenceURL"];
    NSString *imageName = [imagePath lastPathComponent];
    chosenImageNameLabel.text=imageName;
    [picker dismissViewControllerAnimated:YES completion:^{
        [self openEditor:nil];
    }];
}
#pragma mark - End

#pragma mark - PECropViewControllerDelegate methods

- (void)cropViewController:(PECropViewController *)controller didFinishCroppingImage:(UIImage *)croppedImage transform:(CGAffineTransform)transform cropRect:(CGRect)cropRect
{
    [controller dismissViewControllerAnimated:YES completion:NULL];
    //    userImageView.image = croppedImage;
    //    UIImage *image=[self scaleImage:croppedImage];
    
    croppedImage = [UIImage imageWithData:UIImageJPEGRepresentation(croppedImage, 0.2)];
    
    //  goalImageView.image = croppedImage;
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
    
    [controller dismissViewControllerAnimated:YES completion:NULL];
}
#pragma mark - End




#pragma mark - API CALL
-(void)getEventTagListApiCall {
    
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            apiCount++;
            if (contentView) {
                [contentView removeFromSuperview];
            }
            contentView = [Utility activityIndicatorView:self];
        });
        
        NSURLSession *customSession = [NSURLSession sharedSession];
        
        NSError *error;
        
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetEventTagListApiCall" append:@""forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[customSession dataTaskWithRequest:request
                                                          completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                                  apiCount--;
                                                                  if (contentView && apiCount == 0) {
                                                                      [contentView removeFromSuperview];
                                                                  }
                                                                  if(error == nil)
                                                                  {
                                                                      NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                      NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                      if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [responseDict objectForKey:@"Count"]>0) {
                                                                          tagArray = [responseDict objectForKey:@"Tags"];
                                                                          NSLog(@"\n\n tagarray: \n %@",tagArray);
                                                                          //
                                                                          //                                                                          if (apiCount == 0) {
                                                                          //                                                                              [forumTable reloadData];
                                                                          //                                                                              //chayan 21/9/2017
                                                                          //                                                                              [self parseTag];
                                                                          //                                                                          }
                                                                      }
                                                                      else{
                                                                          [Utility msg:[responseDict objectForKey:@"ErrorMessage"] title:@"Error !" controller:self haveToPop:NO];
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


-(void)addNewForumApiCall:(UIImage *)image {
    
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            apiCount++;
            if (contentView) {
                [contentView removeFromSuperview];
            }
            contentView = [Utility activityIndicatorView:self];
        });
        
        
        NSURLSession *customSession = [NSURLSession sharedSession];
        
        NSError *error;
        
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"UserID"] forKey:@"UserID"];
        [mainDict setObject:@"" forKey:@"FacebookToken"];
        [mainDict setObject:forumNameTextField.text forKey:@"Name"];
        
        if (![Utility isEmptyCheck:forumOverviewTextField.text]) {
            [mainDict setObject:forumOverviewTextField.text forKey:@"Overview"];
        }
        else{
            [mainDict setObject:@"" forKey:@"Overview"];
        }
        
        if (![Utility isEmptyCheck:forumDescriptionTextView.text]) {
            [mainDict setObject:forumDescriptionTextView.text forKey:@"Description"];
        }
        else{
            [mainDict setObject:@"" forKey:@"Description"];
        }
        
        if (![Utility isEmptyCheck:forumRulesTextView.text]) {
            [mainDict setObject:forumRulesTextView.text forKey:@"Rules"];
        }
        else{
            [mainDict setObject:@"" forKey:@"Rules"];
        }
        
        //[mainDict setObject:@"" forKey:@"PhotoData"];
        
        
        NSMutableArray *array = [[NSMutableArray alloc]init];
        if ([selectTagButton.titleLabel.text caseInsensitiveCompare:@"Select one or more tags.."] != NSOrderedSame) {
            NSArray *titleArray = [selectTagButton.titleLabel.text componentsSeparatedByString:@", "];
            for (int i =0;i<titleArray.count;i++) {
                NSString *title = [titleArray objectAtIndex:i];
                for (int j = 0; j < tagArray.count; j++) {
                    NSDictionary *dict = [tagArray objectAtIndex:j];
                    if ([[dict objectForKey:@"Description"] caseInsensitiveCompare:title] == NSOrderedSame) {
                        [array addObject:[dict objectForKey:@"EventTagID"]];
                    }
                }
                
            }
        }
        //  NSLog(@"\narray:\n %@",array);
        
        [mainDict setObject:array forKey:@"Tags"];
        
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        NSLog(@"\n json string: \n %@",jsonString);
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"AddNewForum" append:@""forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[customSession dataTaskWithRequest:request
                                                          completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                                  apiCount--;
                                                                  if (contentView && apiCount == 0) {
                                                                      [contentView removeFromSuperview];
                                                                  }
                                                                  if(error == nil)
                                                                  {
                                                                      NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                      NSLog(@"\n response string: \n %@",responseString);
                                                                      NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                      if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"] boolValue]) {
                                                                          [Utility msg:@"Forum created successfully." title:@"Success !" controller:self haveToPop:YES];
                                                                      }
                                                                      else{
                                                                          [Utility msg:[responseDict objectForKey:@"ErrorMessage"] title:@"Error !" controller:self haveToPop:NO];
                                                                          return;
                                                                      }
                                                                  }else{
                                                                      [Utility msg:error.localizedDescription title:@"Error !" controller:self haveToPop:NO];
                                                                  }
                                                              });
                                                              
                                                          }];
        [dataTask resume];
        //
    }else{
        [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
    }
}



- (void) addNewForumApiCallWithImageUpload{
    if (Utility.reachable) {
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"UserID"] forKey:@"UserID"];
        [mainDict setObject:@"" forKey:@"FacebookToken"];
        [mainDict setObject:forumNameTextField.text forKey:@"Name"];
        
        if (![Utility isEmptyCheck:forumOverviewTextField.text]) {
            [mainDict setObject:forumOverviewTextField.text forKey:@"Overview"];
        }
        else{
            [mainDict setObject:@"" forKey:@"Overview"];
        }
        
        if (![Utility isEmptyCheck:forumDescriptionTextView.text]) {
            [mainDict setObject:forumDescriptionTextView.text forKey:@"Description"];
        }
        else{
            [mainDict setObject:@"" forKey:@"Description"];
        }
        
        if (![Utility isEmptyCheck:forumRulesTextView.text]) {
            [mainDict setObject:forumRulesTextView.text forKey:@"Rules"];
        }
        else{
            [mainDict setObject:@"" forKey:@"Rules"];
        }
        NSMutableArray *array = [[NSMutableArray alloc]init];
        if ([selectTagButton.titleLabel.text caseInsensitiveCompare:@"Select one or more tags.."] != NSOrderedSame) {
            NSArray *titleArray = [selectTagButton.titleLabel.text componentsSeparatedByString:@", "];
            for (int i =0;i<titleArray.count;i++) {
                NSString *title = [titleArray objectAtIndex:i];
                for (int j = 0; j < tagArray.count; j++) {
                    NSDictionary *dict = [tagArray objectAtIndex:j];
                    if ([[dict objectForKey:@"Description"] caseInsensitiveCompare:title] == NSOrderedSame) {
                        [array addObject:[dict objectForKey:@"EventTagID"]];
                    }
                }
                
            }
        }
        [mainDict setObject:array forKey:@"Tags"];
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        ProgressBarViewController *controller=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ProgressBar"];
        controller.delegate=self;
        controller.apiName=@"AddNewForum";
        controller.appendString=@"";
        controller.jsonString=jsonString;
        controller.chosenImage=chosenImage;
        controller.modalPresentationStyle = UIModalPresentationCustom;
        [self presentViewController:controller animated:YES completion:nil];
    }
    else{
        [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
    }
    
}




#pragma Mark End



#pragma mark - Dropdown Delegate
- (void) didSelectAnyDropdownOptionMultiSelect:(NSDictionary *)selectedData isAdd:(BOOL)isAdd {
    NSString *title = [selectTagButton currentTitle];
    if (![Utility isEmptyCheck:selectedData] && selectedData.count > 0) {            if ([title caseInsensitiveCompare:@"Select one or more tags.."] != NSOrderedSame) {
        if (isAdd) {
            [selectTagButton setTitle:[NSString stringWithFormat:@"%@, %@",title,[selectedData objectForKey:@"Description"]] forState:UIControlStateNormal];
        } else {
            NSArray *titleArr = [title componentsSeparatedByString:@", "];
            NSMutableArray *titleMutableArr = [titleArr mutableCopy];
            for (int i = 0; i < titleMutableArr.count; i++) {
                if ([titleMutableArr containsObject:[selectedData objectForKey:@"Description"]]) {
                    [titleMutableArr removeObject:[selectedData objectForKey:@"Description"]];
                }
            }
            if (titleMutableArr.count > 0)
                [selectTagButton setTitle:[titleMutableArr componentsJoinedByString:@", "] forState:UIControlStateNormal];
            else
                [selectTagButton setTitle:@"Select one or more tags.." forState:UIControlStateNormal];
        }
    } else {
        [selectTagButton setTitle:[selectedData objectForKey:@"Description"] forState:UIControlStateNormal];
        
    }
    }
}


#pragma Mark End





//chayan 13/10/2017
#pragma mark progressbar delegate

- (void) completedWithResponse:(NSString *)responseString responseDict:(NSDictionary *)responseDict{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"] boolValue]) {
            [Utility msg:@"Forum created successfully." title:@"Success !" controller:self haveToPop:YES];
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



















