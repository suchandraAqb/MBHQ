//
//  WaterTrackerDetailsViewController.m
//  Squad
//
//  Created by AQB Solutions-Mac Mini 2 on 26/02/19.
//  Copyright © 2019 AQB Solutions. All rights reserved.
//

#import "WaterTrackerDetailsViewController.h"
#import "Utility.h"

@interface WaterTrackerDetailsViewController ()
{
    IBOutlet UIButton *addWaterButton;
    IBOutlet UIButton *subtractWaterButton;
    IBOutlet UIButton *addHundredPButton;
    IBOutlet UIButton *subHundredPButton;
    IBOutlet UILabel *dayLabel;
    IBOutlet UILabel *percentageOfdrankLabel;
    IBOutlet UILabel *litredrankLabel;
    IBOutlet UIView *addSubtractView;
    IBOutlet UILabel *addsubtractAddLabel;
    IBOutlet UILabel *currentDrantStatusLabel;
    UIView *contentView;
    double waterLitre;
    BOOL isSub;
    float waterTobeNotAddedValue;
    BOOL isWaterAmountSave;
}
@end

static float defaultWaterGoal = 2.2;

@implementation WaterTrackerDetailsViewController
@synthesize delegate;
#pragma Mark - View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareView];
}
#pragma mark - End

#pragma mark - IBAction
-(IBAction)itemButtonPressed:(id)sender{
    if (sender==addWaterButton) {
        isSub = false;
        addSubtractView.hidden = false;
        [self prepareAddSubView];
    }else if (sender == subtractWaterButton){
        isSub = true;
        addSubtractView.hidden = false;
        [self prepareAddSubView];
    }else if (sender == addHundredPButton){
        waterTobeNotAddedValue = waterLitre;
        waterLitre = waterLitre+0.1;
        [self getpercenatgeOfDrankWater:waterLitre IsValueNotAdded:NO];
        addSubtractView.hidden = true;
        [self addUpdateWaterTrack_webServiceCall];
    }else{
        waterTobeNotAddedValue = waterLitre;
        waterLitre = waterLitre-0.1;
        [self getpercenatgeOfDrankWater:waterLitre IsValueNotAdded:NO];
        addSubtractView.hidden = true;
        [self addUpdateWaterTrack_webServiceCall];
    }
      [self buttonShowHideDetails];
}
-(IBAction)crossButtonPressed:(id)sender{
    if (isWaterAmountSave) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self dismissViewControllerAnimated:YES completion:^{
            if ([self->delegate respondsToSelector:@selector(dataReload:)]) {
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                NSString *dt =[self->_trackDict objectForKey:@"IntakeDateAsString"];
                NSDate *date = [dateFormatter dateFromString:dt];
                [self->delegate dataReload:date];
            }
        }];
    }
 
}
-(IBAction)addSubtractCrossPressed:(id)sender{
    addSubtractView.hidden =true;
}
-(IBAction)addSubtractViewDetails:(UIButton*)sender{
    if (sender.tag == 0) {
            if (!isSub) {
                waterTobeNotAddedValue = waterLitre;
                waterLitre = waterLitre+0.25;
            }else{
                waterTobeNotAddedValue = waterLitre;
                waterLitre = waterLitre-0.25;
            }
    }else if (sender.tag == 1){
            if (!isSub) {
                waterTobeNotAddedValue = waterLitre;
                waterLitre = waterLitre+0.5;
            }else{
                waterTobeNotAddedValue = waterLitre;
                waterLitre = waterLitre-0.5;
            }
    }else if (sender.tag == 2){
            if (!isSub) {
                waterTobeNotAddedValue = waterLitre;
                waterLitre = waterLitre+0.75;
            }else{
                waterTobeNotAddedValue = waterLitre;
                waterLitre = waterLitre-0.75;
            }
    }else{
            if (!isSub) {
                waterTobeNotAddedValue = waterLitre;
                waterLitre = waterLitre+1;
            }else{
                waterTobeNotAddedValue = waterLitre;
                waterLitre = waterLitre-1;
            }
    }
    [self getpercenatgeOfDrankWater:waterLitre IsValueNotAdded:NO];
    addSubtractView.hidden = true;
    [self buttonShowHideDetails];
    [self addUpdateWaterTrack_webServiceCall];
}
#pragma mark  - End

#pragma mark - Private Function

-(void)prepareView{
    if (![Utility isEmptyCheck:_trackDict]) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];

        NSDate *date = [formatter dateFromString:[_trackDict objectForKey:@"IntakeDateAsString"]];
        
        [formatter setDateFormat:@"EEEE"];
        NSString *weekdayStr = [formatter stringFromDate:date];
        
        [formatter setDateFormat:@"dd"];
        NSString *dayStr = [formatter stringFromDate:date];
        
        [formatter setDateFormat:@"MMMM"];
        NSString *monthStr = [formatter stringFromDate:date];
       
        dayLabel.text = [@"" stringByAppendingFormat:@"%@ %@ %@\nYou've Consumed",(![Utility isEmptyCheck:weekdayStr])?weekdayStr:@"",(![Utility isEmptyCheck:dayStr])?dayStr:@"",(![Utility isEmptyCheck:monthStr])?monthStr:@""];
        float amount = [[_trackDict objectForKey:@"amount"]floatValue];
        [self getpercenatgeOfDrankWater:[self convertToLitre:amount] IsValueNotAdded:NO];
        
        [self buttonShowHideDetails];
    }
}
-(void)prepareAddSubView{
    addsubtractAddLabel.layer.borderColor = [Utility colorWithHexString:@"E425A0"].CGColor;
    addsubtractAddLabel.layer.borderWidth = 1;
    if (!isSub) {
        addsubtractAddLabel.text = @"Add Water";
    }else{
        addsubtractAddLabel.text = @"Subtract Water";
    }
    currentDrantStatusLabel.text =[@"" stringByAppendingFormat:@"You've Consumed %@",litredrankLabel.text];
    currentDrantStatusLabel.layer.borderColor = [Utility colorWithHexString:@"E425A0"].CGColor;
    currentDrantStatusLabel.layer.borderWidth=1;
}
-(void)getpercenatgeOfDrankWater:(float)waterlitre IsValueNotAdded:(BOOL)isnotadded{

    if (isnotadded) {
        waterLitre = waterTobeNotAddedValue;
    }else{
        waterLitre = waterlitre;
    }
    if (waterLitre<=0.0) {
        waterLitre = 0.0;
    }
    float waterGoal = ![Utility isEmptyCheck:[_trackDict objectForKey:@"goalAmount"]]?[[_trackDict objectForKey:@"goalAmount"]floatValue]:0.0;
    waterGoal = waterGoal/1000.0;//convert to litre
    if (waterGoal <= 0.0) {
        waterGoal = defaultWaterGoal;
    }
    float waterDrankpercentage = (waterLitre/waterGoal)*100;
    percentageOfdrankLabel.text = [@"" stringByAppendingFormat:@"(%0.2f%%)",waterDrankpercentage];
    litredrankLabel.text =[NSString stringWithFormat:@"%@ Litres",[Utility customRoundNumber:waterLitre]];

//    litredrankLabel.text =[NSString stringWithFormat:@"%@ L of %@L",[Utility customRoundNumber:waterLitre],[Utility customRoundNumber:waterGoal]];
}
-(float)convertToLitre:(float)miliLitre{
    return miliLitre/1000;
}

-(void)buttonShowHideDetails{
    if (![percentageOfdrankLabel.text isEqualToString:@"0.00%"]) {
        subHundredPButton.hidden = false;
        subtractWaterButton.hidden = false;
    }else{
        subHundredPButton.hidden = true;
        subtractWaterButton.hidden = true;
    }
    addWaterButton.hidden = false;
    addHundredPButton.hidden = false;
}
#pragma mark - End

#pragma mark - Api Call
-(void)addUpdateWaterTrack_webServiceCall{
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
        [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        
        NSMutableDictionary *trackDict = [[NSMutableDictionary alloc]init];
        if (![Utility isEmptyCheck:[_trackDict objectForKey:@"id"]]) {
            [trackDict setObject:[_trackDict objectForKey:@"id"] forKey:@"id"];
        }
        if (![Utility isEmptyCheck:[_trackDict objectForKey:@"IntakeDateAsString"]]) {
                [trackDict setObject:[_trackDict objectForKey:@"IntakeDateAsString"] forKey:@"IntakeDateAsString"];
        }
        [trackDict setObject:[defaults objectForKey:@"UserID"] forKey:@"user_id"];
        [trackDict setObject:[NSNumber numberWithInt:[[Utility customRoundNumber:waterLitre] floatValue]*1000] forKey:@"amount"];
        
        
        if (![Utility isEmptyCheck:[_trackDict objectForKey:@"topStreakCount"]]) {
            [trackDict setObject:[_trackDict objectForKey:@"topStreakCount"] forKey:@"topStreakCount"];
        }
        if (![Utility isEmptyCheck:[_trackDict objectForKey:@"lastStreakCount"]]) {
            [trackDict setObject:[_trackDict objectForKey:@"lastStreakCount"] forKey:@"lastStreakCount"];
        }
        if (![Utility isEmptyCheck:[_trackDict objectForKey:@"goalAmount"]]) {
            [trackDict setObject:[_trackDict objectForKey:@"goalAmount"] forKey:@"goalAmount"];
        }
        [mainDict setObject:trackDict forKey:@"TrackModel"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        NSLog(@"\n\n %@",jsonString);
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"AddUpdateWaterTrack" append:@""forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 if (self->contentView) {
                                                                     [self->contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     
                                                                     NSLog(@"\n\n %@",responseString);
                                                                     
                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"SuccessFlag"]boolValue]) {
                                                                         self->isWaterAmountSave=true;
//                                                                         [self dismissViewControllerAnimated:YES completion:^{
                                                                             if ([self->delegate respondsToSelector:@selector(dataReload:)]) {
                                                                                 
                                                                                 NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                                                                                 [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                                                                                 NSDictionary *dict = [responseDict objectForKey:@"TrackModel"];
                                                                                 NSString *dt = [dict objectForKey:@"IntakeDateAsString"];
                                                                                 NSDate *date = [dateFormatter dateFromString:dt];
                                                                                 [self->delegate dataReload:date];
                                                                             }
//                                                                         }];
                                                                         
                                                                     }
                                                                     else{
                                                                         [self getpercenatgeOfDrankWater:self->waterLitre IsValueNotAdded:YES];
                                                                         [Utility msg:[responseDict objectForKey:@"ErrorMessage"] title:@"Error !" controller:self haveToPop:NO];
                                                                         return;
                                                                     }
                                                                 }else{
                                                                     [self getpercenatgeOfDrankWater:self->waterLitre IsValueNotAdded:YES];
                                                                     [Utility msg:error.localizedDescription title:@"Error !" controller:self haveToPop:NO];
                                                                 }
                                                             });
                                                             
                                                         }];
        [dataTask resume];
        
    }else{
        [self getpercenatgeOfDrankWater:self->waterLitre IsValueNotAdded:YES];
        [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
    }
    
}
#pragma mark - End
@end
