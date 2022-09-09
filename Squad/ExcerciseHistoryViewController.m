//
//  ExcerciseHistoryViewController.m
//  Squad
//
//  Created by AQB Solutions-Mac Mini 2 on 26/10/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import "ExcerciseHistoryViewController.h"
#import "Utility.h"
#import "ExerciseHistorySectionHeader.h"
#import "ExcerciseHistoryTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ExcerciseHistoryViewController ()
{
    IBOutlet UITableView *histroyTable;
    IBOutlet UIView *noSessionView;
    IBOutlet UILabel *exerciseLabel;
    NSArray *sessionHistoryModelsArray;
    UIView *contentView;
    IBOutlet UIImageView *exerciseImageView;//AY 21112017
}
@end

@implementation ExcerciseHistoryViewController
@synthesize excerciseId,exerciseName,exerciseImageURL,isShowImage;

#pragma mark - IBAction
- (IBAction)backButtonPressed:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - Private Function
-(void)webServiceCall_squadSessionHistory:(int)excerciseId{
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
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        [mainDict setObject:[NSNumber numberWithInt:excerciseId] forKey:@"ExerciseId"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"SquadSessionHistory" append:@""forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 if (contentView) {
                                                                     [contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"]boolValue]) {
                                                                         
                                                                         NSDictionary *sessionHistory = [responseDict objectForKey:@"SessionHistory"];
                                                                         if (![Utility isEmptyCheck:sessionHistory]) {
                                                                             sessionHistoryModelsArray = [sessionHistory objectForKey:@"SessionHistoryModels"];
                                                                             if (![Utility isEmptyCheck:sessionHistoryModelsArray] && sessionHistoryModelsArray.count>0) {
                                                                                 histroyTable.hidden = false;
                                                                                 noSessionView.hidden = true;
                                                                                 [histroyTable reloadData];
                                                                             }else{
                                                                                 histroyTable.hidden = true;
                                                                                 noSessionView.hidden = false;
                                                                             }
                                                                         }
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
#pragma mark - View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
     noSessionView.hidden = true;
    if (![Utility isEmptyCheck:exerciseName]) {
        exerciseLabel.text = exerciseName;
    }
    if (isShowImage){
        exerciseImageView.hidden = false;
        [exerciseImageView sd_setImageWithURL:[NSURL URLWithString:exerciseImageURL]
                             placeholderImage:[UIImage imageNamed:@"EXERCISE-picture-coming.jpg"] options:SDWebImageScaleDownLargeImages];
    }else{
        exerciseImageView.hidden = true;
        UINib *sectionHeaderNib = [UINib nibWithNibName:@"ExerciseHistorySectionHeader" bundle:nil];
        [histroyTable registerNib:sectionHeaderNib forHeaderFooterViewReuseIdentifier:@"ExerciseHistorySectionHeader"];
        [self webServiceCall_squadSessionHistory:excerciseId];
    }//AY 21112017
}

#pragma mark - End

#pragma mark - Memory Warning

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - End

#pragma mark - TableView DataSource & Delegate
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return sessionHistoryModelsArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 61;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    ExerciseHistorySectionHeader *sectionHeaderView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"ExerciseHistorySectionHeader"];
    if (![Utility isEmptyCheck:[[sessionHistoryModelsArray objectAtIndex:section]objectForKey:@"Date"]]) {
        NSDictionary *sectionDict = [sessionHistoryModelsArray objectAtIndex:section];
        NSString *dateString = [sectionDict objectForKey:@"Date"];
        NSString *newDateString =@"";
        
        if (![Utility isEmptyCheck:dateString]) {
            NSRange range = [dateString rangeOfString:@"T"];
            if (range.location != NSNotFound) {
                newDateString = [dateString substringToIndex:range.location];
            }else{
                newDateString = dateString;
            }
            
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"yyyy-MM-dd"];
            NSDate *date = [dateFormat dateFromString:newDateString];
            [dateFormat setTimeZone:[NSTimeZone systemTimeZone]];
            [dateFormat setDateFormat:@"EEEE,dd MMMM yyyy"];
            NSString *finalDate =@"";
            if (![Utility isEmptyCheck:[dateFormat stringFromDate:date]]) {
                finalDate = [finalDate stringByAppendingFormat:@"%@",[dateFormat stringFromDate:date]];
            }
            sectionHeaderView.dateLabel.text = finalDate;
        }
    }
    return sectionHeaderView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *dict = [sessionHistoryModelsArray objectAtIndex:section];
    NSArray *setsArray = [dict objectForKey:@"Sets"];
    return setsArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"ExcerciseHistoryTableViewCell";
    ExcerciseHistoryTableViewCell *cell;
    cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[ExcerciseHistoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSDictionary *dict = [sessionHistoryModelsArray objectAtIndex:indexPath.section];
    NSArray *setsArray = [dict objectForKey:@"Sets"];
    NSDictionary *setsDict = [setsArray objectAtIndex:indexPath.row];
    
    if (![Utility isEmptyCheck:[setsDict objectForKey:@"SetNo"]]) {
        cell.setLabel.text = [@"" stringByAppendingFormat:@"%ld",indexPath.row+1];
    }
    
    if (![Utility isEmptyCheck:[setsDict objectForKey:@"Weight"]]) {
        float weight = [[setsDict objectForKey:@"Weight"] floatValue];
        
        if(weight>0.0){
            if ([[defaults objectForKey:@"UnitPreference"] intValue] == 0 || [[defaults objectForKey:@"UnitPreference"] intValue] == 1) {
                
                NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
                formatter.numberStyle = NSNumberFormatterDecimalStyle;
                formatter.maximumFractionDigits = 2;
                
                cell.weightLabel.text = [@"" stringByAppendingFormat:@"%@ kg",[formatter stringFromNumber:[NSNumber numberWithFloat:weight]]];
                
            }else{
                CGFloat lb = weight * 2.2046;
                NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
                formatter.numberStyle = NSNumberFormatterDecimalStyle;
                formatter.maximumFractionDigits = 2;
                cell.weightLabel.text = [@"" stringByAppendingFormat:@"%@ lb",[formatter stringFromNumber:[NSNumber numberWithFloat:lb]]];
            }
        }else if (![Utility isEmptyCheck:[setsDict objectForKey:@"Rep"]] && weight == 0.0) {
            cell.weightLabel.text = @"N/A";
        }
         
     }
    
    if (![Utility isEmptyCheck:[setsDict objectForKey:@"Rep"]]) {
        cell.repGoalLabel.text = [@"" stringByAppendingFormat:@"%@",[setsDict objectForKey:@"Rep"]];
    }
    if (![Utility isEmptyCheck:[setsDict objectForKey:@"RepGoal"]]) {
        cell.repsLabel.text = [@"" stringByAppendingFormat:@"%d",[[setsDict objectForKey:@"RepGoal"]intValue]];
    }

    return cell;
}
@end
