//
//  WinTheWeekResultViewController.m
//  Squad
//
//  Created by Admin on 01/02/21.
//  Copyright © 2021 AQB Solutions. All rights reserved.
//

#import "WinTheWeekResultViewController.h"
#import "WinTheWeekResultListViewController.h"

@interface WinTheWeekResultViewController (){
    IBOutlet UIView *popupView;
    IBOutlet UIView *dayCircleView;
    IBOutlet UIView *weekCircleView;
    
    IBOutlet UILabel *dayCountLabel;
    IBOutlet UILabel *weekCountLabel;
    IBOutlet UIButton *crossButton;
    IBOutlet UIView *infoView;
    
    
    UIView *contentView;
    NSDictionary *dataDict;
}

@end

@implementation WinTheWeekResultViewController

#pragma mark - View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    popupView.layer.cornerRadius = 10;
    popupView.layer.masksToBounds=YES;
    
    dayCircleView.layer.cornerRadius = dayCircleView.frame.size.height / 2;
    dayCircleView.layer.masksToBounds=YES;
    
    weekCircleView.layer.cornerRadius = weekCircleView.frame.size.height / 2;
    weekCircleView.layer.masksToBounds=YES;
    infoView.hidden=true;
    
    [self getWinTheWeekStats];
}

#pragma mark - End

#pragma mark -IBActions

- (IBAction)infoCrossPressed:(UIButton *)sender {
    infoView.hidden=true;
}

- (IBAction)questionButtonPressed:(UIButton *)sender {
    infoView.hidden=false;
}

- (IBAction)backButtonPressed:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

- (IBAction)dayButtonPressed:(UIButton *)sender {
    WinTheWeekResultListViewController  *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"WinTheWeekResultList"];
    controller.dataDict=dataDict;
    controller.winType=@"DAY";
    [self.navigationController pushViewController:controller animated:NO];
}

- (IBAction)weekButtonPressed:(UIButton *)sender {
    WinTheWeekResultListViewController  *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"WinTheWeekResultList"];
    controller.dataDict=dataDict;
    controller.winType=@"WEEK";
    [self.navigationController pushViewController:controller animated:NO];
}

#pragma mark - End

#pragma mark - API Call
-(void)getWinTheWeekStats{
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
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetWinTheWeekStats" append:@""forAction:@"POST"];
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
                                                                         
                                                                         self->dataDict=responseDict;
                                                                         int dayCount=[[responseDict objectForKey:@"DayWins"] intValue];
                                                                         int weekCount=[[responseDict objectForKey:@"WeeklyWins"] intValue];
                                                                         
                                                                         self->dayCountLabel.text=[NSString stringWithFormat:@"%d",dayCount];
                                                                         self->weekCountLabel.text=[NSString stringWithFormat:@"%d",weekCount];
                                                                         
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
