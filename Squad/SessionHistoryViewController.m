//
//  SessionHistoryViewController.m
//  Squad
//
//  Created by AQB Solutions-Mac Mini 2 on 26/10/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import "SessionHistoryViewController.h"
#import "WeightRecordHeaderView.h"
#import "WeightRecordTableViewCell.h"
#import "SessionHistoryDataView.h"
static NSString *SectionHeaderViewIdentifier = @"WeightRecordHeaderView";
@interface SessionHistoryViewController ()
{
    IBOutlet UITableView *weightListTable;
    IBOutlet UIView *noSessionView;
    IBOutlet UILabel *sessionExerciseLabel;
    UIView *contentView;
    NSArray *weightRecordList;
    
}
@end

@implementation SessionHistoryViewController
@synthesize excerciseId,exerciseName;
#pragma mark - IBAction
- (IBAction)backButtonPressed:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - End

#pragma mark - Private Function
#pragma mark - Private Function
-(void)webServiceCall_SquadExerciseSessionHistory{
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
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"SquadExerciseSessionHistory" append:@""forAction:@"POST"];
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
                                                                             weightRecordList =[sessionHistory objectForKey:@"SquadWeightSheet"];
                                                                             if (![Utility isEmptyCheck:weightRecordList] && weightRecordList.count>0) {
                                                                                 weightListTable.hidden = false;
                                                                                 noSessionView.hidden = true;
                                                                                 [weightListTable reloadData];
                                                                             }else{
                                                                                 weightListTable.hidden = true;
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
    UINib *sectionHeaderNib = [UINib nibWithNibName:@"WeightRecordHeaderView" bundle:nil];
    [weightListTable registerNib:sectionHeaderNib forHeaderFooterViewReuseIdentifier:SectionHeaderViewIdentifier];
    weightListTable.hidden = true;
    noSessionView.hidden = true;
    if (![Utility isEmptyCheck:exerciseName]) {
        sessionExerciseLabel.text = exerciseName;
    }
    [self webServiceCall_SquadExerciseSessionHistory];
}
#pragma mark - End

#pragma mark - Memory Warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - End
#pragma mark -Tableview Delefate and Datasource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return weightRecordList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSDictionary *sectionDict = [weightRecordList objectAtIndex:section];
    
    NSLog(@"%ld",section);
    
    if(![Utility isEmptyCheck:sectionDict[@"SquadWeightSheetSetsDataModels"]]){
        NSArray *weightArray = sectionDict[@"SquadWeightSheetSetsDataModels"];
        if(![Utility isEmptyCheck:weightArray]){
            NSDictionary *dict = [weightArray firstObject];
            if([Utility isEmptyCheck:dict[@"CircuitId"]]){
                return 1;
            }
            NSDictionary *dataDict = weightArray[0];
            if(![Utility isEmptyCheck:dataDict[@"WeightSheetCircuitModels"]]){
                NSArray *arr = dataDict[@"WeightSheetCircuitModels"];
                int rowCount = 0;
                for(NSDictionary *dict in arr){
                    if(![Utility isEmptyCheck:dict[@"CircuitSetsModels"]]){
                        rowCount++;
                    }
                }
                
                return rowCount;
                
            }
        }
        
        return weightArray.count;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    // Removes extra padding in Grouped style
    
    return UITableViewAutomaticDimension;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section{
    return 60;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    // Removes extra padding in Grouped style
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    WeightRecordHeaderView *sectionHeaderView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:SectionHeaderViewIdentifier];
    //    sectionHeaderView.layer.borderColor = [Utility colorWithHexString:@"66C8DB"].CGColor;
    //    sectionHeaderView.layer.borderWidth = 2.0;
    //    sectionHeaderView.layer.cornerRadius = 5.0;
    //    sectionHeaderView.clipsToBounds = YES;
    sectionHeaderView.bgView.backgroundColor = [UIColor clearColor];
    NSString *exercisename = @"";
    
    NSDictionary *sectionDict = [weightRecordList objectAtIndex:section];
    if(![Utility isEmptyCheck:sectionDict[@"SquadWeightSheetSetsDataModels"]]){
        NSArray *arr = sectionDict[@"SquadWeightSheetSetsDataModels"];
        NSDictionary *dict = [arr objectAtIndex:0];
        if (![Utility isEmptyCheck:dict]) {
            exercisename = [dict objectForKey:@"ExerciseSessionName"];
        }
    }
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
        [dateFormat setDateFormat:@"MMM dd yyyy"];
        if (![Utility isEmptyCheck:[dateFormat stringFromDate:date]]) {
            exercisename = [exercisename stringByAppendingFormat:@" - %@",[dateFormat stringFromDate:date]];
        }
    }
    
    sectionHeaderView.bgView.backgroundColor = [Utility colorWithHexString:@"9BBEFA"]; //AY 27112017
    sectionHeaderView.exerciseNameLabel.textColor = [UIColor whiteColor]; //AY 27112017

    sectionHeaderView.exerciseNameLabel.text = exercisename;
    return sectionHeaderView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    NSString *CellIdentifier =@"WeightRecordTableViewCell";
    WeightRecordTableViewCell *cell;
    
    cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[WeightRecordTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *sectionDict = [weightRecordList objectAtIndex:indexPath.section];
    
    if(![Utility isEmptyCheck:sectionDict[@"SquadWeightSheetSetsDataModels"]]){
        
        NSArray *weightDataArray = sectionDict[@"SquadWeightSheetSetsDataModels"];
        cell.separatorView.hidden = false;
        cell.circuitNameLabel.text = @"";
        
        if(![Utility isEmptyCheck:weightDataArray]){
            NSDictionary *weightData = weightDataArray[0];
            
            if(![Utility isEmptyCheck:weightData] && ![Utility isEmptyCheck:weightData[@"WeightSheetCircuitModels"]]){
                
                NSArray *WeightSheetCircuitModels = weightData[@"WeightSheetCircuitModels"];
                
                NSMutableArray *modifiedArray = [[NSMutableArray alloc]init];
                for(NSDictionary *dataDict in WeightSheetCircuitModels){
                    
                    if(![Utility isEmptyCheck:dataDict] && ![Utility isEmptyCheck:dataDict[@"CircuitSetsModels"]]){
                        [modifiedArray addObject:dataDict];
                    }
                }
                
                NSDictionary *dict = modifiedArray[indexPath.row];
            
                if(![Utility isEmptyCheck:dict] && ![Utility isEmptyCheck:dict[@"CircuitSetsModels"]]){
                    
                    NSString *circuitName = @"";
                    if(![Utility isEmptyCheck:dict] && ![Utility isEmptyCheck:dict[@"ExerciseName"]]){
                        circuitName = dict[@"ExerciseName"];
                    }
                    cell.circuitNameLabel.text = [@"" stringByAppendingFormat:@"\u2022 %@", circuitName];
            
            
                    NSArray *views = cell.weightSheetStackView.arrangedSubviews;
                    if(views.count>0){
                        for(SessionHistoryDataView *view in views){
                            [view removeFromSuperview];
                        }
                    }
            
                    NSArray *circuitSets = dict[@"CircuitSetsModels"];
                    for(int i = 0;i < circuitSets.count ; i++){
                        SessionHistoryDataView *dataView = [SessionHistoryDataView instantiateView];
                        
                        //                            dataView.layer.borderColor = [Utility colorWithHexString:@"F427AB"].CGColor;
                        //                            dataView.layer.borderWidth = 1.0;
                        //                            dataView.layer.cornerRadius = 3.0;
                        //                            dataView.clipsToBounds = YES;
                        
                        [dataView updateData:circuitSets[i]];
                        [cell.weightSheetStackView addArrangedSubview:dataView];
                    }
                    
                }
                
                
            }else if([Utility isEmptyCheck:weightData[@"CircuitId"]]){
                NSString *circuitName = @"";
                if(![Utility isEmptyCheck:weightData[@"ExerciseName"]]){
                    circuitName = weightData[@"ExerciseName"];
                }
                cell.circuitNameLabel.text = circuitName;
                NSArray *views = cell.weightSheetStackView.arrangedSubviews;
                if(views.count>0){
                    for(SessionHistoryDataView *view in views){
                        [view removeFromSuperview];
                    }
                }
                if(![Utility isEmptyCheck:weightData[@"ExerciseSetsModels"]]){
                    NSArray *circuitSets = weightData[@"ExerciseSetsModels"];
                    for(int i = 0;i < circuitSets.count ; i++){
                        SessionHistoryDataView *dataView = [SessionHistoryDataView instantiateView];
                        
                        //                            dataView.layer.borderColor = [Utility colorWithHexString:@"F427AB"].CGColor;
                        //                            dataView.layer.borderWidth = 1.0;
                        //                            dataView.layer.cornerRadius = 3.0;
                        //                            dataView.clipsToBounds = YES;
                        
                        [dataView updateData:circuitSets[i]];
                        [cell.weightSheetStackView addArrangedSubview:dataView];
                    }
                }
            }else{
                cell.circuitNameLabel.text = @"";
                cell.separatorView.hidden = true;
            }
        }else{
            cell.circuitNameLabel.text = @"";
            cell.separatorView.hidden = true;
        }
    }else{
        cell.circuitNameLabel.text = @"";
        cell.separatorView.hidden = true;
    }
    
    cell.addSetButton.tag = indexPath.section;
    cell.addSetButton.accessibilityHint = [@"" stringByAppendingFormat:@"%ld",indexPath.row];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
#pragma mark - End
@end

