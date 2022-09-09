//
//  MyDairyAddEditViewController.m
//  Squad
//
//  Created by AQB Solutions-Mac Mini 2 on 07/03/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import "MyDairyAddEditViewController.h"
#import "NSString+HTML.h"
@interface MyDairyAddEditViewController (){
    
    IBOutlet UIButton *editButton;

    IBOutlet UIButton *dateButton;
    IBOutlet UIButton *saveButton;
    IBOutlet UIButton *cancelButton;
    IBOutlet UIButton *backButton;

    IBOutlet UIButton *deleteButton;
    IBOutlet UIView *webViewContainer;

    NSDate *selectedDate;
    UIView *contentView;
    BOOL isChanged;
}
@end

@implementation MyDairyAddEditViewController
@synthesize diaryData,isEdit,editor;
;


#pragma mark - IBAction
- (IBAction)editButonPressed:(UIButton *)sender {
    if (diaryData) {
        if (isEdit) {
            isEdit= false;
        }else{
            isEdit = true;
        }
        [self prepareView];
    }
    
}
- (IBAction)saveButonPressed:(UIButton *)sender {
    [self addEditMyDiary];
}
- (IBAction)cancelButonPressed:(UIButton *)sender {
    [self shouldPopOnBackButtonWithResponse:^(BOOL shouldPop) {
        if (shouldPop) {
            if(diaryData){
                isEdit= false;
                isChanged = NO;
                [Utility stopFlashingbutton:saveButton];
                [self prepareView];
            }else{
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }];
    
    
}
- (IBAction)deleteButonPressed:(UIButton *)sender {
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Delete confirmation"
                                  message:@"Are you sure you want to delete this dairy?"
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"Confirm"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [self deleteDiary];
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
- (IBAction)logoButtonPressed:(UIButton *)sender {
    [self shouldPopOnBackButtonWithResponse:^(BOOL shouldPop) {
        if (shouldPop) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }];
}
- (IBAction)showMenu:(id)sender {
    [self shouldPopOnBackButtonWithResponse:^(BOOL shouldPop) {
        if (shouldPop) {
            [self.slidingViewController anchorTopViewToRightAnimated:YES];
            [self.slidingViewController resetTopViewAnimated:YES];
        }
    }];
    
}
- (IBAction)backButtonPressed:(id)sender {
    [self shouldPopOnBackButtonWithResponse:^(BOOL shouldPop) {
        if (shouldPop) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}
#pragma mark - end

#pragma mark - Private Method
-(void)getDairySelectApiCall{
    if (Utility.reachable) {
        
        NSURLSession *achieveSession = [NSURLSession sharedSession];
        
        NSError *error;
        
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:[diaryData objectForKey:@"Id"] forKey:@"DairyID"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (contentView) {
                [contentView removeFromSuperview];
            }
            contentView = [Utility activityIndicatorView:self];
        });
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetDairySelectApiCall" append:@"" forAction:@"POST"];
        
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
                                                                           diaryData = [[responseDictionary objectForKey:@"Details"] mutableCopy];
                                                                           if (![Utility isEmptyCheck:diaryData]) {
                                                                               NSString *createdDate = [diaryData objectForKey:@"DueDate"];
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
                                                                               
                                                                               [self prepareView];
                                                                           }else{
                                                                               diaryData = [[NSMutableDictionary alloc]init];
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

-(void)deleteDiary{
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
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults valueForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:[diaryData valueForKey:@"Id"] forKey:@"DairyID"];

        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"DeleteDairyApiCall" append:@"" forAction:@"POST"];
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
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDictionary] && [[responseDictionary objectForKey:@"SuccessFlag"] boolValue]) {
                                                                         [Utility msg:@"Diary Deleted Successfully. " title:@"Success !" controller:self haveToPop:YES];
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
-(void)addEditMyDiary{
    if (Utility.reachable) {
        
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults valueForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        NSMutableDictionary *modelDict=[[NSMutableDictionary alloc]init];
        NSString *html = [editor getHTML];
        NSLog(@"%@",html);
        if (![Utility isEmptyCheck:html]) {
            [modelDict setObject:html forKey:@"Details"];
        }else{
            [Utility msg:@"Please write your diary ." title:@"Warning !" controller:self haveToPop:NO];
            return;
            
        }
        if (![Utility isEmptyCheck:selectedDate]) {
            NSDateFormatter *dateFormatter = [NSDateFormatter new];
            [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
            [dateFormatter setDateFormat:@"yyyy-MM-dd'T'hh:mm:ss"];
            NSString *date = [dateFormatter stringFromDate:selectedDate];
            [modelDict setObject:date forKey:@"DueDate"];
        }else{
            [Utility msg:@"Please select date." title:@"Warning !" controller:self haveToPop:NO];
            return;
        }
        if (diaryData) {
            [modelDict setObject:[diaryData valueForKey:@"CreatedBy"] forKey:@"CreatedBy"];
        }else{
            [modelDict setObject:[defaults valueForKey:@"UserID"] forKey:@"CreatedBy"];
        }
        if (diaryData) {
            [modelDict setObject:[diaryData valueForKey:@"CreatedBy"] forKey:@"CreatedBy"];
        }else{
            [modelDict setObject:[defaults valueForKey:@"UserID"] forKey:@"CreatedBy"];
        }

        if (diaryData) {
            [modelDict setObject:[diaryData valueForKey:@"CreatedAt"] forKey:@"CreatedAt"];
        }else{
            [modelDict setObject:@"" forKey:@"CreatedAt"];
        }
        if (diaryData) {
            [modelDict setObject:[diaryData valueForKey:@"Id"] forKey:@"Id"];
        }else{
            [modelDict setObject:[NSNumber numberWithInt:0] forKey:@"Id"];
        }
        if (diaryData) {
            [modelDict setObject:[diaryData valueForKey:@"IsDeleted"] forKey:@"IsDeleted"];
        }else{
            [modelDict setObject:[NSNumber numberWithBool:false] forKey:@"IsDeleted"];
        }
        if (diaryData) {
            [modelDict setObject:[diaryData valueForKey:@"Status"] forKey:@"Status"];
        }else{
            [modelDict setObject:[NSNumber numberWithBool:false] forKey:@"Status"];
        }
        [mainDict setObject:modelDict forKey:@"model"];

        dispatch_async(dispatch_get_main_queue(), ^{
            if (contentView) {
                [contentView removeFromSuperview];
            }
            contentView = [Utility activityIndicatorView:self];
        });
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"AddUpdateDairyApiCall" append:@"" forAction:@"POST"];
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
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDictionary] && [[responseDictionary objectForKey:@"SuccessFlag"] boolValue]) {
                                                                         isChanged = NO;
                                                                         [Utility stopFlashingbutton:saveButton];

                                                                         if (diaryData) {
//                                                                             [Utility msg:@"Diary Edited Successfully. " title:@"Success !" controller:self haveToPop:YES];
                                                                         }else{
//                                                                         [Utility msg:@"Diary Added Successfully. " title:@"Success !" controller:self haveToPop:YES];
                                                                         }
                                                                         
                                                                         [self.navigationController popViewControllerAnimated:YES];
                                                                        // [self dismissViewControllerAnimated:YES completion:nil];

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

-(void)prepareView{
    [self.view endEditing:YES];
    NSString *detailsString = [diaryData objectForKey:@"Details"];
    if (![Utility isEmptyCheck:detailsString]) {
        [editor setHTML:detailsString];
    }else{
        [editor setPlaceholder:@"Please write your diary ."];
    }
    if (!isEdit){
        if (![Utility isEmptyCheck:diaryData]) {
            deleteButton.hidden = false;
        }else{
            deleteButton.hidden = true;
        }
        editButton.hidden = false;
        saveButton.hidden = true;
        cancelButton.hidden = true;
        backButton.hidden = false;
        [editor disableTextEditor];
    }else{
        deleteButton.hidden = true;
        editButton.hidden = true;
        saveButton.hidden = false;
        cancelButton.hidden = false;
        backButton.hidden = true;
        [editor enableTextEditor];
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
#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    webViewContainer.layer.borderWidth = 1.0f;
    webViewContainer.layer.borderColor = [[Utility colorWithHexString:@"F427AB"] CGColor];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    editor = [storyboard instantiateViewControllerWithIdentifier:@"NewMyDiaryAddEdit"];
    [self addChildViewController:editor];
    CGRect frame = editor.view.frame;
    frame.size.height = CGRectGetHeight(webViewContainer.frame);
    frame.size.width = CGRectGetWidth(webViewContainer.frame);
    editor.view.frame = frame;
    editor.delegate = self;
    [webViewContainer addSubview:editor.view];
    [editor didMoveToParentViewController:self];
    selectedDate = nil;
    if (![Utility isEmptyCheck:diaryData]) {
        [self getDairySelectApiCall];
    }
    isChanged = NO;
    [Utility stopFlashingbutton:saveButton];
    
    [self prepareView];
}
-(void)viewWillAppear:(BOOL)animated{
    if(isChanged){
        [Utility startFlashingbutton:saveButton];
    }
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
-(void)viewDidDisappear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationController.navigationBar.translucent = NO;
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
-(void)isTextChanged:(BOOL)value{
    isChanged = YES;
    [Utility startFlashingbutton:saveButton];

}
#pragma  mark -End
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
