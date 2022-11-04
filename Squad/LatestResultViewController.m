//
//  LatestResultViewController.m
//  Squad
//
//  Created by AQB Solutions-Mac Mini 2 on 20/03/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import "LatestResultViewController.h"
#import "Utility.h"
#import "MasterMenuViewController.h"
#import "AddDetailsViewController.h"
#import "AddDetailsViewController.h"
#import "CompareResultViewController.h"

@interface LatestResultViewController ()
{
    IBOutlet UIScrollView *mainScroll;
    IBOutlet UIView *weightView;
    IBOutlet UIView *measurementsView;
    IBOutlet UIView *referencetopView;
    IBOutlet UIView *referencepantView;
    
    IBOutlet UIButton *wDate;
    IBOutlet UITextField *wWeight;
    IBOutlet UITextField *wFatPercentage;
    IBOutlet UITextField *wBodyFatkg;
    IBOutlet UITextField *wLeanMuscle;
    
    IBOutlet UIButton *mDate;
    IBOutlet UITextField *mChest;
    IBOutlet UITextField *mStomach;
    IBOutlet UITextField *mHips;
    IBOutlet UITextField *mLeg;
    IBOutlet UITextField *mArm;
    IBOutlet UITextField *mTotal;
    
    IBOutlet UIButton *rtDate;
    IBOutlet UITextField *rtBrand;
    IBOutlet UITextField *rtSize;
    IBOutlet UIButton *rtFeelButton;
    
    IBOutlet UIButton *rpDate;
    IBOutlet UITextField *rpBrand;
    IBOutlet UITextField *rpSize;
    IBOutlet UIButton *rpFeelButton;
    
    IBOutlet UIStackView *weightDetailsStackView;
    IBOutlet UIStackView *measurmentsDeatilsStackView;
    IBOutlet UIStackView *rtDetailsSatckView;
    IBOutlet UIStackView *rpDetailsStackView;
    
    IBOutlet UIView *weightlabelView;
    IBOutlet UIView *weightDetailsView;
    IBOutlet UIView *measurmentlabelView;
    IBOutlet UIView *measurmentDetailsView;
    IBOutlet UIView *rtlabelView;
    IBOutlet UIView *rtDetailsView;
    IBOutlet UIView *rplabelView;
    IBOutlet UIView *rpDetailsView;

    
    
    UITextField *activeTextField;
    int apiCount;
    UIView *contentView;
    NSDate *selectedDate;
    NSString *selectedResultData;
    NSString *currentWDate;
    NSString *currentMDate;
    NSString *currentRTDate;
    NSString *currenRPDate;
    NSDictionary *weightData;
    NSDictionary *measurementData;
    NSDictionary *topData;
    NSDictionary *pantData;
    NSString *searchDate;
    NSString *searchFor;
    double bodyweight; //add_su_2/8/17
    
    
    
    IBOutletCollection(UILabel) NSArray *weightNmeasurementLabelArray;
    
}
@end

@implementation LatestResultViewController

#pragma mark - IBAction
- (IBAction)menuTapped:(id)sender {
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
    [self.slidingViewController resetTopViewAnimated:YES];
}

- (IBAction)logoTapped:(id)sender {
    [self.navigationController  popToRootViewControllerAnimated:YES];
}

- (IBAction)backTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)editButtonPressed:(UIButton*)sender{
    AddDetailsViewController *controller=[self.storyboard instantiateViewControllerWithIdentifier:@"AddDetailsView"];
    if (sender.tag == 0) {
        controller.dataDict = [weightData mutableCopy];
        controller.type= @"Body Weight Composition";
        controller.selectedFields = @[@"BodyWeight",@"BodyFatPercentage",@"BodyFatKgs",@"MuscleKg"];
    }else if (sender.tag == 1) {
        controller.type = @"Body Measurement Composition";
        controller.dataDict = [measurementData mutableCopy];
        controller.selectedFields = @[@"Chest",@"Stomach",@"Hips",@"Leg",@"Arm",@"Total"];
        
    }else if (sender.tag == 2) {
        controller.type = @"Refrence Top";
        controller.dataDict = [topData mutableCopy];
        controller.selectedFields= @[@"Brand",@"PantSize",@"Feel"];
    }else if (sender.tag == 3) {
        controller.type = @"Refrence Pant Composition";
        controller.dataDict = [pantData mutableCopy];
        controller.selectedFields= @[@"Brand",@"PantSize",@"Feel"];
    }
    [self.navigationController pushViewController:controller animated:YES];
}
-(IBAction)deleteButtonPressed:(UIButton*)sender{
    NSString *warning =@"";
    NSString *api = @"";
    NSNumber *deleteId;
    if (sender.tag == 0) {
        warning = @"Body Weight Composition";
        api = @"DeleteBodyCompositionApiCall";
        deleteId = weightData[@"BodyCompositionId"];
        
    }else if (sender.tag == 1) {
        warning = @"Body Measurement Composition";
        api = @"DeleteBodyCompositionApiCall";
        deleteId = measurementData[@"BodyCompositionId"];
        
    }else if (sender.tag == 2) {
        warning = @"Refrence Top";
        api = @"DeleteRefrenceApiCall";
        deleteId = topData[@"ReferenceClothDataId"];
    }else if (sender.tag == 3) {
        warning = @"Refrence Pant Composition";
        api = @"DeleteRefrenceApiCall";
        deleteId = pantData[@"ReferenceClothDataId"];
    }
    NSString  *warningTotalString = [warning stringByAppendingString:@" will be Deleted ! Are you really sure?"];
    
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Delete confirmation"
                                  message:warningTotalString
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"Confirm"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [self deleteCompareData:deleteId api:api deleteType:warning];
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
-(IBAction)searchButtonPressed:(UIButton*)sender{
    if (sender.tag == 0) {
       searchFor = @"weight";
    }else if (sender.tag == 1) {
        searchFor = @"measurement";
    }else if (sender.tag == 2) {
        searchFor = @"top";
    }else if (sender.tag == 3) {
        searchFor = @"pant";
    }
    /*DatePickerViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DatePicker"];
    controller.modalPresentationStyle = UIModalPresentationCustom;
    controller.selectedDate = [NSDate date];
    controller.datePickerMode = UIDatePickerModeDate;
    controller.delegate = self;
    [self presentViewController:controller animated:YES completion:nil];*/
    
    CompareResultViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CompareResult"];
    controller.isFromLatestResult = YES;
    controller.selectedIndex = (int)sender.tag;
    [self.navigationController pushViewController:controller animated:YES];
}

-(IBAction)addButtonPressed:(UIButton*)sender{
    AddDetailsViewController *controller=[self.storyboard instantiateViewControllerWithIdentifier:@"AddDetailsView"];
    if (sender.tag == 0) {
        controller.type= @"Body Weight Composition";
        controller.prevWeight = [[weightData objectForKey:@"BodyWeight"]doubleValue]; //add_su_2/8/17
        controller.selectedFields = @[@"BodyWeight",@"BodyFatPercentage",@"BodyFatKgs",@"MuscleKg"];
    }else if (sender.tag == 1) {
        controller.type = @"Body Measurement Composition";
        controller.selectedFields = @[@"Chest",@"Stomach",@"Hips",@"Leg",@"Arm",@"Total"];
        
    }else if (sender.tag == 2) {
        controller.type = @"Refrence Top";
        controller.selectedFields= @[@"Brand",@"PantSize",@"Feel"];
    }else if (sender.tag == 3) {
        controller.type = @"Refrence Pant Composition";
        controller.selectedFields= @[@"Brand",@"PantSize",@"Feel"];
    }
    [self.navigationController pushViewController:controller animated:YES];
}


#pragma mark - End

#pragma mark - Webservicecall

-(void)getBodyWeightApiCall{
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            apiCount++;
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
        [mainDict setObject:[defaults valueForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"UnitPreference"] forKey:@"UnitPreference"];
        if (![Utility isEmptyCheck:searchFor] && [searchFor isEqualToString:@"weight"] && ![Utility isEmptyCheck:searchDate]) {
            [mainDict setObject:searchDate forKey:@"Date"];
            searchFor=nil;
            searchDate=nil;
        }
        
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetBodyWeight" append:@"" forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 apiCount--;
                                                                 if (contentView && apiCount == 0) {
                                                                     [contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDictionary] && [[responseDictionary objectForKey:@"SuccessFlag"]boolValue]) {
                                                                         NSDictionary *BodyCompositionWeightDict = [responseDictionary objectForKey:@"BodyCompositionWeight"];
                                                                         if (![Utility isEmptyCheck:BodyCompositionWeightDict] && ![Utility isEmptyCheck: mainDict[@"Date"] ]) {
                                                                             [Utility msg:@"No Data Found" title:@"Error" controller:self haveToPop:NO];
                                                                             return;
                                                                         }
                                                                         if (![Utility isEmptyCheck:BodyCompositionWeightDict] && [BodyCompositionWeightDict[@"BodyCompositionId"] intValue] != -1) {
                                                                             
                                                                             weightData=BodyCompositionWeightDict;
                                                                             //[weightDetailsStackView addArrangedSubview:weightDetailsView];
                                                                             weightDetailsView.hidden = false;
                                                                             if (![Utility isEmptyCheck:[BodyCompositionWeightDict objectForKey:@"DateAdded"]]) {
                                                                                 NSString *dateAddedString =[BodyCompositionWeightDict objectForKey:@"DateAdded"];
                                                                                 static NSDateFormatter *dateFormatter;
                                                                                 dateFormatter = [NSDateFormatter new];
                                                                                 dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
                                                                                 NSDate *date = [dateFormatter dateFromString:dateAddedString];
                                                                                 [dateFormatter setDateFormat:@"dd-MMM-yyyy"];
                                                                                 NSString *wdateString = [dateFormatter stringFromDate:date];
                                                                                 [wDate setTitle:wdateString forState:UIControlStateNormal];
                                                                                 
                                                                             }
                                                                             NSString *bodyWeight =[@""stringByAppendingFormat:@"%@",[BodyCompositionWeightDict objectForKey:@"BodyWeight"]];
                                                                             
                                                                             wWeight.text = ![Utility isEmptyCheck:bodyWeight] ? bodyWeight : @"";
                                                                             
                                                                             NSString *bodyFatPercentage = [@""stringByAppendingFormat:@"%@",[BodyCompositionWeightDict objectForKey:@"BodyFatPercentage"]];
                                                                             wFatPercentage.text = ![Utility isEmptyCheck:bodyFatPercentage] ? bodyFatPercentage : @"";
                                                                             
                                                                             NSString *bodyFatKg = [@""stringByAppendingFormat:@"%@",[BodyCompositionWeightDict objectForKey:@"BodyFatKgs"]];
                                                                             wBodyFatkg.text = ![Utility isEmptyCheck:bodyFatKg] ? bodyFatKg : @"";
                                                                             
                                                                             NSString *muscleKg = [@""stringByAppendingFormat:@"%@",[BodyCompositionWeightDict objectForKey:@"MuscleKg"]];
                                                                             wLeanMuscle.text = ![Utility isEmptyCheck:muscleKg] ? muscleKg : @"";
                                                                         }
                                                                     }
                                                                     else{
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
        dispatch_async(dispatch_get_main_queue(), ^{
            [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:YES];
            return;
        });
        
    }
}

-(void)bodyMeasurementsApiCall{
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            apiCount++;
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
        [mainDict setObject:[defaults valueForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"UnitPreference"] forKey:@"UnitPreference"];
        if (![Utility isEmptyCheck:searchFor] && [searchFor isEqualToString:@"measurement"] && ![Utility isEmptyCheck:searchDate]) {
            [mainDict setObject:searchDate forKey:@"Date"];
            searchFor=nil;
            searchDate=nil;
        }

        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"BodyMeasurements" append:@"" forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 apiCount--;
                                                                 if (contentView && apiCount == 0) {
                                                                     [contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDictionary] && [[responseDictionary objectForKey:@"SuccessFlag"]boolValue]) {
                                                                         NSDictionary *BodyCompositionWeightDict = [responseDictionary objectForKey:@"BodyCompositionWeight"];
                                                                         if (![Utility isEmptyCheck:BodyCompositionWeightDict] && ![Utility isEmptyCheck: mainDict[@"Date"] ]) {
                                                                             [Utility msg:@"No Data Found" title:@"Error" controller:self haveToPop:NO];
                                                                             return;
                                                                         }
                                                                         if (![Utility isEmptyCheck:BodyCompositionWeightDict] && [BodyCompositionWeightDict[@"BodyCompositionId"] intValue] != -1) {
                                                                             //[measurmentsDeatilsStackView addArrangedSubview:measurmentDetailsView];
                                                                             measurementData  = BodyCompositionWeightDict;
                                                                             measurmentDetailsView.hidden = false;

                                                                             if (![Utility isEmptyCheck:[BodyCompositionWeightDict objectForKey:@"DateAdded"]]) {
                                                                                 static NSDateFormatter *dateFormatter;
                                                                                 dateFormatter = [NSDateFormatter new];
                                                                                 dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
                                                                                 NSDate *date = [dateFormatter dateFromString:[BodyCompositionWeightDict objectForKey:@"DateAdded"]];
                                                                                 [dateFormatter setDateFormat:@"dd-MMM-yyyy"];
                                                                                 NSString *mdateString = [dateFormatter stringFromDate:date];
                                                                                 [mDate setTitle:mdateString forState:UIControlStateNormal];
                                                                             }

                                                                             NSString *chest =[@""stringByAppendingFormat:@"%@",[BodyCompositionWeightDict objectForKey:@"Chest"]];
                                                                             mChest.text = ![Utility isEmptyCheck:chest] ? chest : @"";
                                                                             
                                                                             NSString *stomach = [@""stringByAppendingFormat:@"%@",[BodyCompositionWeightDict objectForKey:@"Stomach"]];
                                                                             mStomach.text = ![Utility isEmptyCheck:stomach] ? stomach : @"";
                                                                             
                                                                             NSString *hips = [@""stringByAppendingFormat:@"%@",[BodyCompositionWeightDict objectForKey:@"Hips"]];
                                                                             mHips.text = ![Utility isEmptyCheck:hips] ? hips : @"";
                                                                             
                                                                             NSString *leg = [@""stringByAppendingFormat:@"%@",[BodyCompositionWeightDict objectForKey:@"Leg"]];
                                                                             mLeg.text = ![Utility isEmptyCheck:leg] ? leg : @"";
                                                                             
                                                                             NSString *arm = [@""stringByAppendingFormat:@"%@",[BodyCompositionWeightDict objectForKey:@"Arm"]];
                                                                             mArm.text = ![Utility isEmptyCheck:leg] ? arm : @"";
                                                                             
                                                                             NSString *total = [@""stringByAppendingFormat:@"%@",[BodyCompositionWeightDict objectForKey:@"Total"]];
                                                                             mTotal.text = ![Utility isEmptyCheck:leg] ? total : @"";
                                                                         }
                                                                     }
                                                                     else{
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
        dispatch_async(dispatch_get_main_queue(), ^{
            [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:YES];
            return;
        });
        
    }
}

-(void)getBodyRefrenceTopApiCall{
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            apiCount++;
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
        [mainDict setObject:[defaults valueForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"UnitPreference"] forKey:@"UnitPreference"];
        if (![Utility isEmptyCheck:searchFor] && [searchFor isEqualToString:@"top"] && ![Utility isEmptyCheck:searchDate]) {
            [mainDict setObject:searchDate forKey:@"Date"];
            searchFor=nil;
            searchDate=nil;
        }
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetBodyRefrenceTop" append:@"" forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 apiCount--;
                                                                 if (contentView && apiCount == 0) {
                                                                     [contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDictionary] && [[responseDictionary objectForKey:@"SuccessFlag"]boolValue]) {
                                                                         NSDictionary *bodyRefrenceTopDict = [responseDictionary objectForKey:@"BodyClothModel"];
                                                                         if (![Utility isEmptyCheck:bodyRefrenceTopDict] && ![Utility isEmptyCheck: mainDict[@"Date"] ]) {
                                                                             [Utility msg:@"No Data Found" title:@"Error" controller:self haveToPop:NO];
                                                                             return;
                                                                         }
                                                                         if (![Utility isEmptyCheck:bodyRefrenceTopDict] && [bodyRefrenceTopDict[@"ReferenceClothDataId"] intValue] != -1) {
                                                                             
                                                                             //[rtDetailsSatckView addArrangedSubview:rtDetailsView];
                                                                             topData = bodyRefrenceTopDict;
                                                                             rtDetailsView.hidden = false;

                                                                             if (![Utility isEmptyCheck:[bodyRefrenceTopDict objectForKey:@"DateAdded"]]) {
                                                                                 static NSDateFormatter *dateFormatter;
                                                                                 dateFormatter = [NSDateFormatter new];
                                                                                 dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
                                                                                 NSDate *date = [dateFormatter dateFromString:[bodyRefrenceTopDict objectForKey:@"DateAdded"]];
                                                                                 [dateFormatter setDateFormat:@"dd-MMM-yyyy"];
                                                                                 NSString *rtdateString = [dateFormatter stringFromDate:date];
                                                                                 [rtDate setTitle:rtdateString forState:UIControlStateNormal];
                                                                                 
                                                                             }

                                                                             NSString *brand =[@""stringByAppendingFormat:@"%@",[bodyRefrenceTopDict objectForKey:@"Brand"]];
                                                                             rtBrand.text = ![Utility isEmptyCheck:brand] ? brand : @"";
                                                                             
                                                                             NSString *stomach = [@""stringByAppendingFormat:@"%@",[bodyRefrenceTopDict objectForKey:@"PantSize"]];
                                                                             rtSize.text = ![Utility isEmptyCheck:stomach] ? stomach : @"";
                                                                             
                                                                             NSString *feel = [@""stringByAppendingFormat:@"%@",[feelType objectForKey:[bodyRefrenceTopDict objectForKey:@"Feel"]]];
                                                                             
                                                                             if (![Utility isEmptyCheck:feel]) {
                                                                                 [rtFeelButton setTitle:feel forState:UIControlStateNormal];
                                                                             }else{
                                                                                 [rtFeelButton setTitle:@"" forState:UIControlStateNormal];
                                                                             }
                                                                         }
                                                                     }
                                                                     else{
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
        dispatch_async(dispatch_get_main_queue(), ^{
            [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:YES];
            return;
        });
        
    }
}

-(void)getBodyRefrencePantApiCall{
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            apiCount++;
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
        [mainDict setObject:[defaults valueForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"UnitPreference"] forKey:@"UnitPreference"];
        if (![Utility isEmptyCheck:searchFor] && [searchFor isEqualToString:@"pant"] && ![Utility isEmptyCheck:searchDate]) {
            [mainDict setObject:searchDate forKey:@"Date"];
            searchFor=nil;
            searchDate=nil;
        }
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetBodyRefrencePant" append:@"" forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 apiCount--;
                                                                 if (contentView && apiCount == 0) {
                                                                     [contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDictionary] && [[responseDictionary objectForKey:@"SuccessFlag"]boolValue]) {
                                                                         NSDictionary *bodyRefrencePantDict = [responseDictionary objectForKey:@"BodyClothModel"];
                                                                         if (![Utility isEmptyCheck:bodyRefrencePantDict] && ![Utility isEmptyCheck: mainDict[@"Date"] ]) {
                                                                             [Utility msg:@"No Data Found" title:@"Error" controller:self haveToPop:NO];
                                                                             return;
                                                                         }
                                                                         if (![Utility isEmptyCheck:bodyRefrencePantDict] && [bodyRefrencePantDict[@"ReferenceClothDataId"] intValue] != -1) {
                                                                             
                                                                             //[rpDetailsStackView addArrangedSubview:rpDetailsView];
                                                                             rpDetailsView.hidden = false;
                                                                             pantData =bodyRefrencePantDict;
                                                                             if (![Utility isEmptyCheck:[bodyRefrencePantDict objectForKey:@"DateAdded"]]) {
                                                                                 static NSDateFormatter *dateFormatter;
                                                                                 dateFormatter = [NSDateFormatter new];
                                                                                 dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
                                                                                 NSDate *date = [dateFormatter dateFromString:[bodyRefrencePantDict objectForKey:@"DateAdded"]];
                                                                                 [dateFormatter setDateFormat:@"dd-MMM-yyyy"];
                                                                                  NSString *rpdateString = [dateFormatter stringFromDate:date];
                                                                                 [rpDate setTitle:rpdateString forState:UIControlStateNormal];

                                                                             }
                                                                             
                                                                             NSString *brand =[@""stringByAppendingFormat:@"%@",[bodyRefrencePantDict objectForKey:@"Brand"]];
                                                                             rpBrand.text = ![Utility isEmptyCheck:brand] ? brand : @"";
                                                                             
                                                                             NSString *stomach = [@""stringByAppendingFormat:@"%@",[bodyRefrencePantDict objectForKey:@"PantSize"]];
                                                                             rpSize.text = ![Utility isEmptyCheck:stomach] ? stomach : @"";
                                                                             
                                                                             NSString *feel = [@""stringByAppendingFormat:@"%@",[feelType objectForKey:[bodyRefrencePantDict objectForKey:@"Feel"]]];
                                                                             
                                                                             if (![Utility isEmptyCheck:feel]) {
                                                                                 [rpFeelButton setTitle:feel forState:UIControlStateNormal];
                                                                             }else{
                                                                                 [rpFeelButton setTitle:@"" forState:UIControlStateNormal];
                                                                             }
                                                                         }
                                                                     }
                                                                     else{
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
        dispatch_async(dispatch_get_main_queue(), ^{
            [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:YES];
            return;
        });
        
    }
}
-(void)deleteCompareData:(NSNumber *)deleteId api:(NSString *)api deleteType:(NSString *)deleteType{
    if (Utility.reachable) {
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:deleteId forKey:@"DataId"];
        [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
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
        NSURLSession *dailySession = [NSURLSession sharedSession];
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:api append:@"" forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[dailySession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(),^ {
                                                                 if (contentView) {
                                                                     [contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDictionary] &&[[responseDictionary objectForKey:@"Success"] boolValue]) {
                                                                         [Utility msg:[deleteType stringByAppendingString:@" Data deleted successfully" ] title:@"Success" controller:self haveToPop:YES];
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

#pragma mark - End

#pragma mark - Private Function
-(void)setView{
    wDate.userInteractionEnabled=false;
    wWeight.userInteractionEnabled=false;
    wFatPercentage.userInteractionEnabled=false;
    wBodyFatkg.userInteractionEnabled=false;
    wLeanMuscle.userInteractionEnabled=false;

    mDate.userInteractionEnabled=false;
    mChest.userInteractionEnabled=false;
    mStomach.userInteractionEnabled=false;
    mHips.userInteractionEnabled=false;
    mLeg.userInteractionEnabled=false;
    mArm.userInteractionEnabled=false;
    mTotal.userInteractionEnabled=false;

    rtDate.userInteractionEnabled=false;
    rtBrand.userInteractionEnabled=false;
    rtSize.userInteractionEnabled=false;
    rtFeelButton.userInteractionEnabled=false;
    rpDate.userInteractionEnabled=false;
    rpBrand.userInteractionEnabled=false;
    rpSize.userInteractionEnabled=false;
    rpFeelButton.userInteractionEnabled=false;
}
#pragma mark - End
#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerForKeyboardNotifications];
    //UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:weightView.bounds];
    weightView.layer.masksToBounds = NO;
    weightView.layer.shadowColor = [Utility colorWithHexString:@"#2e312d"].CGColor;
    weightView.layer.shadowOffset = CGSizeMake(0.0f, 5.0f);
    weightView.layer.shadowOpacity = 0.4f;
    weightView.layer.shadowRadius = 5;
    weightView.layer.cornerRadius = 10;

    //weightView.layer.shadowPath = shadowPath.CGPath;
    
    //UIBezierPath *shadowPathForMeasurements = [UIBezierPath bezierPathWithRect:measurementsView.bounds];
    measurementsView.layer.masksToBounds = NO;
    measurementsView.layer.shadowColor = [Utility colorWithHexString:@"#2e312d"].CGColor;
    measurementsView.layer.shadowOffset = CGSizeMake(0.0f, 5.0f);
    measurementsView.layer.shadowOpacity = 0.4f;
    measurementsView.layer.shadowRadius = 5;
    measurementsView.layer.cornerRadius = 10;
   // measurementsView.layer.shadowPath = shadowPathForMeasurements.CGPath;
    
   // UIBezierPath *shadowPathForReferencetop = [UIBezierPath bezierPathWithRect:referencetopView.bounds];
    referencetopView.layer.masksToBounds = NO;
    referencetopView.layer.shadowColor = [Utility colorWithHexString:@"#2e312d"].CGColor;
    referencetopView.layer.shadowOffset = CGSizeMake(0.0f, 5.0f);
    referencetopView.layer.shadowOpacity = 0.4f;
    //referencetopView.layer.shadowPath = shadowPathForReferencetop.CGPath;
    referencetopView.layer.shadowRadius = 5;
    referencetopView.layer.cornerRadius = 10;
    
   // UIBezierPath *shadowPathForReferencepant = [UIBezierPath bezierPathWithRect:referencepantView.bounds];
    referencepantView.layer.masksToBounds = NO;
    referencepantView.layer.shadowColor = [Utility colorWithHexString:@"#2e312d"].CGColor;
    referencepantView.layer.shadowOffset = CGSizeMake(0.0f, 5.0f);
    referencepantView.layer.shadowOpacity = 0.4f;
    referencepantView.layer.shadowRadius = 5;
    referencepantView.layer.cornerRadius = 10;
    //referencepantView.layer.shadowPath = shadowPathForReferencepant.CGPath;
    
//    feelType = @{
//                         @1:@"Tighter",
//                         @2:@"Looser",
//                         @3:@"The Same",
//                         @4:@"Start Reference"
//                         };
    
     int unitPrefererence = [[defaults objectForKey:@"UnitPreference"] intValue];
    
    for(UILabel *label in weightNmeasurementLabelArray){
        
        
        if(unitPrefererence == 0 || unitPrefererence == 1){
            // Tag 1: Weight Tag 2:Measurements
            if(label.tag == 1){
                label.text = [@"" stringByAppendingFormat:@"%@ (kg) :",label.accessibilityHint];
            }else{
                label.text = [@"" stringByAppendingFormat:@"%@ (cm) :",label.accessibilityHint];
            }
            
        }else {
            // Tag 1: Weight Tag 2:Measurements
            if(label.tag == 1){
                label.text = [@"" stringByAppendingFormat:@"%@ (lb) :",label.accessibilityHint];
            }else{
                label.text = [@"" stringByAppendingFormat:@"%@ (inches) :",label.accessibilityHint];
            }
        }
        
    }//AY 04042018
    
    [self setView];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    if ([Utility isEmptyCheck:searchDate ]) {
        weightDetailsView.hidden = true;
        measurmentDetailsView.hidden = true;
        rtDetailsView.hidden = true;
        rpDetailsView.hidden = true;
        
        //[weightDetailsStackView removeArrangedSubview:weightDetailsView];
        //[measurmentsDeatilsStackView removeArrangedSubview:measurmentDetailsView];
        //[rtDetailsSatckView removeArrangedSubview:rtDetailsView];
        //[rpDetailsStackView removeArrangedSubview:rpDetailsView];
        
        
        apiCount= 0;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self getBodyWeightApiCall];
            [self bodyMeasurementsApiCall];
            [self getBodyRefrenceTopApiCall];
            [self getBodyRefrencePantApiCall];
        });
    }

    
}

#pragma mark - End

#pragma mark - Memory Warning

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    // Store the data
    //    if (activeTextField == emailTextField) {
    //        [passwordTextField becomeFirstResponder];
    //    }
    //    else if (activeTextField == passwordTextField){
    //        //[self loginButtonPress:nil];
    //        [textField resignFirstResponder];
    //    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    activeTextField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    activeTextField = nil;
}

#pragma mark  -End
#pragma  mark -DatePickerViewControllerDelegate
-(void)didSelectDate:(NSDate *)date{
    NSLog(@"%@\n%@",date,[defaults objectForKey:@"Timezone"]);
    if (date) {
        static NSDateFormatter *dateFormatter;
        dateFormatter = [NSDateFormatter new];
        
        //[dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:[defaults objectForKey:@"Timezone"]]];
        [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
        selectedDate = date;
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *dateString = [dateFormatter stringFromDate:date];
        searchDate = dateString;
        if ([searchFor isEqualToString:@"weight"]) {
            [self getBodyWeightApiCall];
        }else if ([searchFor isEqualToString:@"measurement"]) {
            [self bodyMeasurementsApiCall];

        }else if ([searchFor isEqualToString:@"top"]) {
            [self getBodyRefrenceTopApiCall];

        }else if ([searchFor isEqualToString:@"pant"]) {
            [self getBodyRefrencePantApiCall];

        }
    }
}
#pragma  mark -End


@end
