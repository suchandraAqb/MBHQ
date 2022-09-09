//
//  DailyGoodnessViewController.m
//  Squad
//
//  Created by MAC 6- AQB SOLUTIONS on 15/02/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import "DailyGoodnessViewController.h"
#import "DailyGoodnessTableViewCell.h"
#import "ExerciseDailyListHeaderView.h"
#import "ExerciseTypeViewController.h"
#import "HomePageViewController.h"
#import "DailyGoodnessDetailViewController.h"

static NSString *SectionHeaderViewIdentifier = @"ExerciseDailyListHeaderView";

@interface DailyGoodnessViewController (){
    IBOutlet UITableView *dailyTableView;
    NSMutableDictionary *dateListDict;
    UIView *contentView;
    NSMutableArray *responseArray;
    
}

@end

@implementation DailyGoodnessViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    //arnab 17
    dateListDict = [[NSMutableDictionary alloc]init];
    responseArray = [[NSMutableArray alloc]init];
    
    
    UINib *sectionHeaderNib = [UINib nibWithNibName:@"ExerciseDailyListHeaderView" bundle:nil];
    [dailyTableView registerNib:sectionHeaderNib forHeaderFooterViewReuseIdentifier:SectionHeaderViewIdentifier];
    
    [self getDailyData];
    
    //    dailyTableView.estimatedRowHeight = 80;
    //    dailyTableView.rowHeight = UITableViewAutomaticDimension;
    //
    //    dailyTableView.estimatedSectionHeaderHeight = 80;
    //    dailyTableView.sectionHeaderHeight = UITableViewAutomaticDimension;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - webservice Call

-(void) getDailyData {
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (contentView) {
                [contentView removeFromSuperview];
            }
            contentView = [Utility activityIndicatorView:self];
        });
        NSURLSession *dailySession = [NSURLSession sharedSession];
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetDailyMealList" append:@"" forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[dailySession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(),^ {
                                                                 if (contentView) {
                                                                     [contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     
                                                                     //NSLog(@"data by chayan: \n\n %@",responseString);
                                                                     
                                                                     
                                                                     NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDictionary]) {
                                                                         //                                                                         [dateListDict setObject:[[responseDictionary objectForKey:@"DailySessionModels"] objectForKey:@"DailySessionModels"] forKey:monthName];
                                                                         //                                                                         [dailyTableView reloadData];
                                                                         //ah 2.2
                                                                         //ah 6.2
                                                                         if (![[responseDictionary objectForKey:@"Success"] boolValue]) {
                                                                             [Utility msg:[responseDictionary objectForKey:@"ErrorMessage"] title:@"Error!" controller:self haveToPop:NO];
                                                                         } else {
                                                                             [responseArray addObjectsFromArray:[responseDictionary objectForKey:@"List"]];
                                                                             [self setupView];
                                                                         }
                                                                     }else{
                                                                         [Utility msg:@"Something Went Wrong.Please Try Later." title:@"Error !" controller:self haveToPop:NO];
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


#pragma mark - Private Method

-(void) setupView {
        for (int i = 0; i < responseArray.count; i++) {
        NSString *dateStr = [[responseArray objectAtIndex:i] objectForKey:@"MealDate"];
        NSArray *dateArr = [dateStr componentsSeparatedByString:@"T"];
        dateStr = [dateArr objectAtIndex:0];
        
        NSDateFormatter *dailyDateformatter = [[NSDateFormatter alloc]init];
        [dailyDateformatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *dailyDate = [dailyDateformatter dateFromString:dateStr];
        
        NSCalendar* calendar = [NSCalendar currentCalendar];
            NSDateComponents* components = [calendar components:NSCalendarUnitMonth fromDate:dailyDate]; // Get necessary date components
            
            NSDateComponents* yearComponents = [calendar components:NSCalendarUnitYear fromDate:dailyDate]; // Get necessary date components
            
            
            
            NSInteger monthIndex = [components month]; //gives you month
            
            NSInteger yearIndex = [yearComponents year]; //gives you year
            
            NSString *keyName;
            
            if (monthIndex > 9){
                
                keyName= [@"" stringByAppendingFormat:@"%ld-%ld",yearIndex,monthIndex];
                
            }else{
                
                keyName= [@"" stringByAppendingFormat:@"%ld-0%ld",yearIndex,monthIndex];
                
            }
            
            if (![Utility isEmptyCheck:dateListDict]) {
                
                NSArray *keys = [dateListDict allKeys];
                
                if ([keys containsObject:keyName]) { //[NSNumber numberWithInteger:monthIndex]
                    
                    NSMutableArray *newArr = [[NSMutableArray alloc]init];
                    
                    [newArr addObjectsFromArray:[dateListDict objectForKey:keyName]];
                    
                    [newArr addObject:[responseArray objectAtIndex:i]];
                    
                    [dateListDict removeObjectForKey:keyName];
                    
                    [dateListDict setObject:newArr forKey:keyName];
                    
                } else {
                    
                    NSMutableArray *newArr = [[NSMutableArray alloc]init];
                    
                    [newArr addObject:[responseArray objectAtIndex:i]];
                    
                    [dateListDict setObject:newArr forKey:keyName];
                    
                }
                
            } else {
                
                NSMutableArray *newArr = [[NSMutableArray alloc]init];  //ah ah
                
                [newArr addObject:[responseArray objectAtIndex:i]];
                
                [dateListDict setObject:newArr forKey:keyName];
                
                //            [dateListDict setObject:[responseArray objectAtIndex:i] forKey:monthName];
                
            }
    }
    
    NSArray *keys = [dateListDict allKeys];
//    [[keys mutableCopy] sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:nil ascending:NO];
    keys = [keys sortedArrayUsingDescriptors: [NSArray arrayWithObject: sortDescriptor]];
    
    for (int i = 0; i < keys.count; i++) {
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        NSMutableArray *arr1 = [[NSMutableArray alloc] init];
        arr = [dateListDict objectForKey:[keys objectAtIndex:i]];
        for (int j = 0; j < arr.count; j++) {
            if ([[arr objectAtIndex:j] isKindOfClass:[NSDictionary class]]) {
                [arr1 addObject:[arr objectAtIndex:j]];
            }
            NSLog(@"j %d",j);
        }
        [dateListDict removeObjectForKey:[keys objectAtIndex:i]];
        [dateListDict setObject:arr1 forKey:[keys objectAtIndex:i]];
    }
    NSLog(@"dla %@",dateListDict);
    [dailyTableView reloadData];
    @try {
        [self tableView:dailyTableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    } @catch (NSException *exception) {
        //
    }
}

#pragma -mark IBAction
- (IBAction)showMenu:(id)sender {
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
    [self.slidingViewController resetTopViewAnimated:YES];
}
-(IBAction)logoTapped:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)home:(id)sender {
    HomePageViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HomePage"];
    [self.navigationController pushViewController:controller animated:YES];
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return dateListDict.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *keys = [dateListDict allKeys];
//    [[keys mutableCopy] sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:nil ascending:NO];
    keys = [keys sortedArrayUsingDescriptors: [NSArray arrayWithObject: sortDescriptor]];
    
    NSArray *arr = [dateListDict objectForKey:[keys objectAtIndex:section]];
    return arr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    // Removes extra padding in Grouped style
    return CGFLOAT_MIN;
}
-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    ExerciseDailyListHeaderView *sectionHeaderView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:SectionHeaderViewIdentifier];
    
    NSArray *keys = [dateListDict allKeys];
//    [[keys mutableCopy] sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:nil ascending:NO];
    keys = [keys sortedArrayUsingDescriptors: [NSArray arrayWithObject: sortDescriptor]];
    
    NSString *keyName = [keys objectAtIndex:section];
    
    NSArray *temp = [keyName componentsSeparatedByString:@"-"];
    
    NSInteger monthIndex = [temp[1] integerValue];
//    sectionHeaderView.exerciseHeaderTextLabel.text = [[keys objectAtIndex:section] uppercaseString];
    NSDateFormatter *df = [[NSDateFormatter alloc] init] ;
    NSString *monthName = [[df monthSymbols] objectAtIndex:monthIndex-1];
    sectionHeaderView.exerciseHeaderTextLabel.text = [monthName uppercaseString];
    
    return  sectionHeaderView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 60.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //    NSLog(@"ir %ld | is %ld",(long)indexPath.row,(long)indexPath.section);
    NSString *CellIdentifier = @"DailyGoodnessTableViewCell";
    DailyGoodnessTableViewCell *cell;
    cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[DailyGoodnessTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSArray *keys = [dateListDict allKeys];
//    [[keys mutableCopy] sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:nil ascending:NO];
    keys = [keys sortedArrayUsingDescriptors: [NSArray arrayWithObject: sortDescriptor]];
    
    NSArray *arr = [dateListDict objectForKey:[keys objectAtIndex:indexPath.section]];
    NSDictionary *dateDict = [arr objectAtIndex:indexPath.row];
    if (![Utility isEmptyCheck:dateDict]) {
        NSString *dateStr = [dateDict objectForKey:@"MealDate"];
        NSArray *dateArr = [dateStr componentsSeparatedByString:@"T"];
        dateStr = [dateArr objectAtIndex:0];
        
        NSDateFormatter *dailyDateformatter = [[NSDateFormatter alloc]init];
        [dailyDateformatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *dailyDate = [dailyDateformatter dateFromString:dateStr];
        [dailyDateformatter setDateFormat:@"EEEE d"];
        //    endDateLabel.text = [dailyDateformatter stringFromDate:endDate];      2017-01-18T08:28:50.7138494+00:00
        
        NSString *suffix = @"";
        if (![dailyDate isEqual:[NSNull null]]) {
            suffix = [Utility daySuffixForDate:dailyDate];
        }
        cell.dateLabel.text = [NSString stringWithFormat:@"%@%@",[dailyDateformatter stringFromDate:dailyDate],suffix];
        if (![Utility isEmptyCheck:[dateDict objectForKey:@"MealName"]]) {
            cell.mealNameLabel.text = [dateDict objectForKey:@"MealName"];
        } else {
            cell.mealNameLabel.text = [dateDict objectForKey:@"MealName"];
        }   //ah 2.2
        
        //cell.subCatLabel.text = [[arr objectAtIndex:indexPath.row] objectForKey:@"ExerciseSessionType"];
    }

    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *keys = [dateListDict allKeys];
//    [[keys mutableCopy] sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:nil ascending:NO];
    keys = [keys sortedArrayUsingDescriptors: [NSArray arrayWithObject: sortDescriptor]];
    
    NSArray *arr = [dateListDict objectForKey:[keys objectAtIndex:indexPath.section]];
    NSDictionary *dateDict = [arr objectAtIndex:indexPath.row];
    if (![Utility isEmptyCheck:dateDict]) {
        NSLog(@"%@",dateDict);
        NSString *dateStr = [dateDict objectForKey:@"MealDate"];
        NSArray *dateArr = [dateStr componentsSeparatedByString:@"T"];
        dateStr = [dateArr objectAtIndex:0];
        
        NSDateFormatter *dailyDateformatter = [[NSDateFormatter alloc]init];
        [dailyDateformatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *dailyDate = [dailyDateformatter dateFromString:dateStr];
        [dailyDateformatter setDateFormat:@"dd MM yyyy"];
        //    endDateLabel.text = [dailyDateformatter stringFromDate:endDate];      2017-01-18T08:28:50.7138494+00:00
        
        NSString *suffix = @"";
        if (![dailyDate isEqual:[NSNull null]]) {
            suffix = [Utility daySuffixForDate:dailyDate];
        }
        DailyGoodnessDetailViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DailyGoodnessDetail"];
        controller.mealId = [dateDict objectForKey:@"MealId"];
        controller.dateString = [dailyDateformatter stringFromDate:dailyDate];
        controller.fromController = @"Meal";    //ah ux
        controller.showTab = true;
        [self.navigationController pushViewController:controller animated:NO];
    }
}

@end
