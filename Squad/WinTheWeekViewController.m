//
//  WinTheWeekViewController.m
//  Squad
//
//  Created by Admin on 01/02/21.
//  Copyright © 2021 AQB Solutions. All rights reserved.
//

#import "WinTheWeekViewController.h"
#import "WinTheWeekResultViewController.h"

@interface WinTheWeekViewController (){
    IBOutlet UIView *winTheWeekView;
    IBOutlet UILabel *userNameLabel;
    IBOutlet UILabel *winDayWeekLabel;
    IBOutlet UIStackView *buttonStackView;
    IBOutlet UIButton *shareButton;
    IBOutlet UIButton *seeResultButton;
    IBOutlet UIImageView *mannyImageView;
    IBOutlet UIButton *crossButton;
    IBOutlet UILabel *completedInfoLabel;
    IBOutlet UIView *logoView;
    IBOutlet UIView *captureScreenView;
    
    IBOutlet UIView *calenderView;
    IBOutlet UILabel *calenderLabel1;
    IBOutlet UILabel *calenderLabel2;
    
    
    
    UIView *contentView;
}
@end

@implementation WinTheWeekViewController
@synthesize winType,parent,dayDoneCount,WeekStartDateStr,todayDateStr;

#pragma mark - View Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    calenderView.layer.borderColor=[UIColor blackColor].CGColor;
    calenderView.layer.borderWidth=1;
    calenderView.layer.cornerRadius=10;
    calenderView.layer.masksToBounds=YES;
    
    winTheWeekView.layer.cornerRadius=10;
    winTheWeekView.layer.masksToBounds=YES;
    
    shareButton.layer.cornerRadius = 20;
    shareButton.layer.masksToBounds = YES;
    seeResultButton.layer.cornerRadius = 20;
    seeResultButton.layer.masksToBounds = YES;
    
    logoView.hidden=true;
    
    NSLog(@"week start date str--> %@",WeekStartDateStr);
    
    userNameLabel.text=[NSString stringWithFormat:@"Congratulations %@ ,",[defaults objectForKey:@"FirstName"]].capitalizedString;
    if ([winType isEqualToString:@"WEEK"]) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *weekStartDate=[formatter dateFromString:WeekStartDateStr];
        [formatter setDateFormat:@"MMM"];
        NSString *monthstr=[formatter stringFromDate:weekStartDate];
        [formatter setDateFormat:@"d"];
        NSString *dayNumber=[formatter stringFromDate:weekStartDate];
        calenderLabel1.text=[monthstr uppercaseString];
        calenderLabel2.text=dayNumber;
        
        completedInfoLabel.text=[NSString stringWithFormat:@"%d Days Won",dayDoneCount];
        winDayWeekLabel.text=@"WON THE WEEK";
        if (dayDoneCount==4) {
            mannyImageView.image = [UIImage imageNamed:@"4_manny.png"];
        }else if (dayDoneCount==5){
            mannyImageView.image = [UIImage imageNamed:@"5_manny.png"];
        }else if (dayDoneCount==6){
            mannyImageView.image = [UIImage imageNamed:@"6_manny.png"];
        }else if (dayDoneCount==7){
            mannyImageView.image = [UIImage imageNamed:@"7_manny.png"];
        }
    }else if ([winType isEqualToString:@"DAY"]){
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *todayDate=[formatter dateFromString:todayDateStr];
        [formatter setDateFormat:@"E"];
        NSString *dayStr=[formatter stringFromDate:todayDate];
        [formatter setDateFormat:@"d"];
        NSString *dayNumber=[formatter stringFromDate:todayDate];
        calenderLabel1.text=[dayStr uppercaseString];
        calenderLabel2.text=dayNumber;
        
        mannyImageView.image = [UIImage imageNamed:@"manny_thumbsup.png"];
        completedInfoLabel.text=[NSString stringWithFormat:@"100%% Habits Completed"];
        winDayWeekLabel.text=@"WON THE DAY";
    }
    
    [self webSerViceCall_UpdateBadgeShown];
}


- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:NO];
}

#pragma mark - End

#pragma mark - IBActions
- (IBAction)shareButtonPressed:(UIButton *)sender {
    UIImage *shareImage = [self captureView:captureScreenView];
    NSArray *items = @[shareImage];
    
    // build an activity view controller
    UIActivityViewController *controller = [[UIActivityViewController alloc]initWithActivityItems:items applicationActivities:nil];
    
    // and present it
    [self presentActivityController:controller];
}

- (IBAction)seeResultButtonPressed:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        WinTheWeekResultViewController  *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"WinTheWeekResultView"];
        [self.parent.navigationController pushViewController:controller animated:NO];
    }];
}

- (IBAction)cancelButtonPressed:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}

#pragma mark - End

#pragma mark - Private Methods

- (void)presentActivityController:(UIActivityViewController *)controller {
    
    // for iPad: make the presentation a Popover
    controller.modalPresentationStyle = UIModalPresentationPopover;
    [self presentViewController:controller animated:YES completion:nil];
    
    UIPopoverPresentationController *popController = [controller popoverPresentationController];
    popController.permittedArrowDirections = UIPopoverArrowDirectionAny;
    popController.barButtonItem = self.navigationItem.leftBarButtonItem;
    
    // access the completion handler
    controller.completionWithItemsHandler = ^(NSString *activityType,
                                              BOOL completed,
                                              NSArray *returnedItems,
                                              NSError *error){
        // react to the completion
        if (completed) {
            
            // user shared an item
            NSLog(@"We used activity type%@", activityType);
            
        } else {
            
            // user cancelled
            NSLog(@"We didn't want to share anything after all.");
        }
        
        if (error) {
            NSLog(@"An Error occured: %@, %@", error.localizedDescription, error.localizedFailureReason);
        }
    };
}

- (UIImage*)captureView:(UIView *)captureView {
    logoView.hidden=false;
    CGRect rect = captureView.bounds;
    rect.size.height=rect.size.height+41;
    UIGraphicsBeginImageContextWithOptions(rect.size,YES,[UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [captureView.layer renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    logoView.hidden=true;
    return image;
}


#pragma mark - End

#pragma mark - API call

-(void)webSerViceCall_UpdateBadgeShown{
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
        [mainDict setObject:[defaults valueForKey:@"UserID"] forKey:@"UserId"];
        [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:AccessKey forKey:@"Key"];
        
        if ([winType isEqualToString:@"WEEK"]) {
            [mainDict setObject:[NSNumber numberWithBool:YES] forKey:@"IsWeekBadge"];
            [mainDict setObject:WeekStartDateStr forKey:@"ForDate"];
        }else if ([winType isEqualToString:@"DAY"]){
            [mainDict setObject:[NSNumber numberWithBool:NO] forKey:@"IsWeekBadge"];
//            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
//            [formatter setDateFormat:@"yyyy-MM-dd"];
            [mainDict setObject:todayDateStr forKey:@"ForDate"];
        }
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"UpdateBadgeShown" append:@""forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 if (self->contentView) {
                                                                     [self->contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"SuccessFlag"]boolValue]) {
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

#pragma mark - End


@end
