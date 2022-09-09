//
//  CourseNotificationControlViewController.m
//  Squad
//
//  Created by Admin on 20/01/20.
//  Copyright © 2020 AQB Solutions. All rights reserved.
//

#import "CourseNotificationControlViewController.h"

@interface CourseNotificationControlViewController (){
    
    IBOutlet UIView *mainView;
    IBOutletCollection(UIButton) NSArray *statusButtons;
    
    IBOutlet UISwitch *messageNotificationSwitch;
    IBOutlet UISwitch *seminarNotificationSwitch;
    IBOutlet UIButton *resetBUtton;
    
    UIView *contentView;
    int courseStatus;
    BOOL msgNotification_tmp;
    BOOL seminarNotification_temp;
    
    
    
    
}

@end

@implementation CourseNotificationControlViewController

@synthesize course_notification_delegate,courseDetailsDict,messageNotification,seminarNotification;

#pragma mark - View Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    mainView.layer.cornerRadius = 25.0;
    mainView.layer.masksToBounds = YES;
    // Do any additional setup after loading the view.
    resetBUtton.layer.cornerRadius=resetBUtton.frame.size.height/2;
    resetBUtton.backgroundColor=squadMainColor;
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    if (![Utility isEmptyCheck:[courseDetailsDict objectForKey:@"Status"]]) {
        int status=[[courseDetailsDict objectForKey:@"Status"] intValue];
        msgNotification_tmp=messageNotification;
        seminarNotification_temp=seminarNotification;
        courseStatus=status;
        for (UIButton *btn in statusButtons) {
            if (btn.tag==status)
            {
                btn.selected=true;
            } else{
                btn.selected = false;
            }
        }
        
        if (messageNotification ==true) {
            messageNotificationSwitch.on=true;
        }else{
            messageNotificationSwitch.on=false;
        }
        
        if (seminarNotification ==true) {
            seminarNotificationSwitch.on=true;
        }else{
            seminarNotificationSwitch.on=false;
        }
        
    }
    
    
    
    
}

#pragma mark - End



#pragma mark - IBAction

- (IBAction)closeButtonPressed:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)statusButtonsPressed:(UIButton *)sender
{
    if (!sender.isSelected) {
        for (UIButton *btn in statusButtons) {
            if (sender==btn)
            {
                btn.selected=true;
                courseStatus=(int)sender.tag;
            } else{
                btn.selected = false;
            }
        }
        
    }
}
- (IBAction)programNotificationPressed:(UISwitch *)sender {
    if (sender.on) {
        msgNotification_tmp=true;
    }else{
        msgNotification_tmp=false;
    }
//    [self toggleMessageNotificationFlag_WebServiceCall];
}
- (IBAction)seminarNotificationPressed:(UISwitch *)sender {
    if (sender.on) {
        seminarNotification_temp=true;
    }else{
        seminarNotification_temp=false;
    }
    //[self toggleSeminarNotificationFlag_WebServiceCall];
}

- (IBAction)applyButtonPressed:(UIButton *)sender {
//    if (courseStatus!=[[courseDetailsDict objectForKey:@"Status"] intValue]) {
//        [self updateCourseStatus_WebServiceCall];
//    }
    [self updateCourseStatus_WebServiceCall];
}

- (IBAction)resetButtonPressed:(UIButton *)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Warning !" message:@"This is the RESET program button. If you reset your program, all the tasks you have done will be cleared. Do you want to start the program again and have you history erased?" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self->courseStatus=4;
        [self updateCourseStatus_WebServiceCall];
        
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"NO, I want to keep going" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertController addAction:ok];
    [alertController addAction:cancel];
    
    [self presentViewController:alertController animated:YES completion:nil];
}


#pragma mark - End

#pragma mark - Webservice Call

-(void)updateCourseStatus_WebServiceCall{
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(),^ {
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
            self->contentView = [Utility activityIndicatorView:self];
        });
        NSURLSession *dailySession = [NSURLSession sharedSession];
        NSError *error;

        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults valueForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"UserID"] forKey:@"UserId"];
        [mainDict setObject:[courseDetailsDict valueForKey:@"CourseId"] forKey:@"CourseId"];
        [mainDict setObject:[NSString stringWithFormat:@"%d",courseStatus] forKey:@"Status"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];

        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"UpdateCourseStatus" append:@"" forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[dailySession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(),^ {
                                                                 if (self->contentView) {
                                                                     [self->contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSLog(@"Response Data:%@",responseString);
                                                                     NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDictionary] && [[responseDictionary objectForKey:@"SuccessFlag"] boolValue]) {
                                                                         
//                                                                         for (UIButton *btn in self->statusButtons) {
//                                                                             if (btn.tag==self->courseStatus)
//                                                                             {
//                                                                                 btn.selected=true;
//                                                                             } else{
//                                                                                 btn.selected=false;
//                                                                             }
//                                                                         }
                                                                         [self->courseDetailsDict setObject:[NSString stringWithFormat:@"%d",self->courseStatus] forKey:@"Status"];
                                                                         if (self->courseStatus==4) {
                                                                             [self->course_notification_delegate resetCourseData:self->courseDetailsDict isBack:YES];
                                                                             [self dismissViewControllerAnimated:YES completion:nil];
                                                                         }else{
                                                                             if (self->messageNotification != self->msgNotification_tmp) {
                                                                                 [self toggleMessageNotificationFlag_WebServiceCall];
                                                                             }
                                                                             
                                                                             if (self->seminarNotification != self->seminarNotification_temp) {
                                                                                 [self toggleSeminarNotificationFlag_WebServiceCall];
                                                                             }
                                                                             
                                                                             [self->course_notification_delegate resetCourseData:self->courseDetailsDict isBack:YES];
                                                                             [self dismissViewControllerAnimated:YES completion:nil];
                                                                         }
                                                                         
                                                                         
                                                                         }else{
                                                                             [Utility msg:responseDictionary[@"ErrorMessage"] title:@"Oops! " controller:self haveToPop:NO];
                                                                             return;
                                                                         }
                                                                     }else{
                                                                         [Utility msg:@"Somthing went wrong.Please try again later." title:@"Oops! " controller:self haveToPop:NO];
                                                                         return;
                                                                     }
                                                             });
                                                         }];
        [dataTask resume];

    }else{
        [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
    }
}


-(void)toggleSeminarNotificationFlag_WebServiceCall{
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(),^ {
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
            self->contentView = [Utility activityIndicatorView:self];
        });
        NSURLSession *dailySession = [NSURLSession sharedSession];
        NSError *error;

        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults valueForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"UserID"] forKey:@"UserId"];
        [mainDict setObject:[courseDetailsDict valueForKey:@"CourseId"] forKey:@"CourseId"];
//        [mainDict setObject:[NSString stringWithFormat:@"%d",courseStatus] forKey:@"Status"];
        [mainDict setObject:[NSNumber numberWithBool:seminarNotification_temp] forKey:@"On"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];

        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"ToggleSeminarNotificationFlag" append:@"" forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[dailySession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(),^ {
                                                                 if (self->contentView) {
                                                                     [self->contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSLog(@"Response Data:%@",responseString);
                                                                     NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDictionary] && [[responseDictionary objectForKey:@"SuccessFlag"] boolValue]) {
                                                                         
                                                                         }else{
                                                                             [Utility msg:responseDictionary[@"ErrorMessage"] title:@"Oops! " controller:self haveToPop:NO];
                                                                             return;
                                                                         }
                                                                     }else{
                                                                         [Utility msg:@"Somthing went wrong.Please try again later." title:@"Oops! " controller:self haveToPop:NO];
                                                                         return;
                                                                     }
                                                             });
                                                         }];
        [dataTask resume];

    }else{
        [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
    }
}

-(void)toggleMessageNotificationFlag_WebServiceCall{
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(),^ {
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
            self->contentView = [Utility activityIndicatorView:self];
        });
        NSURLSession *dailySession = [NSURLSession sharedSession];
        NSError *error;

        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults valueForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"UserID"] forKey:@"UserId"];
        [mainDict setObject:[courseDetailsDict valueForKey:@"CourseId"] forKey:@"CourseId"];
//        [mainDict setObject:[NSString stringWithFormat:@"%d",courseStatus] forKey:@"Status"];
        [mainDict setObject:[NSNumber numberWithBool:msgNotification_tmp] forKey:@"On"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];

        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"ToggleMessageNotificationFlag" append:@"" forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[dailySession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(),^ {
                                                                 if (self->contentView) {
                                                                     [self->contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSLog(@"Response Data:%@",responseString);
                                                                     NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDictionary] && [[responseDictionary objectForKey:@"SuccessFlag"] boolValue]) {
                                                                         
                                                                         }else{
                                                                             [Utility msg:responseDictionary[@"ErrorMessage"] title:@"Oops! " controller:self haveToPop:NO];
                                                                             return;
                                                                         }
                                                                     }else{
                                                                         [Utility msg:@"Somthing went wrong.Please try again later." title:@"Oops! " controller:self haveToPop:NO];
                                                                         return;
                                                                     }
                                                             });
                                                         }];
        [dataTask resume];

    }else{
        [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
    }
}




#pragma mark - End



@end
