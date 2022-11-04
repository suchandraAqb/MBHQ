//
//  QuoteGalleryViewController.m
//  Squad
//
//  Created by AQB Solutions-Mac Mini 2 on 14/12/18.
//  Copyright © 2018 AQB Solutions. All rights reserved.
//

#import "QuoteGalleryViewController.h"
#import "QuoteMonth.h"
#import "QuoteTableViewCell.h"
#import "Utility.h"
#import "QuoteViewController.h"
@interface QuoteGalleryViewController ()<QuoteSelectDelegate>
{
    IBOutlet UITableView *quoteMonthTable;
    IBOutlet UIButton *viewTodayQuoteButton;
    IBOutlet UISwitch *quoteSwitch;
    NSMutableArray *quoteAllListArr;
    NSMutableArray *quoteDistinctArr;
    NSArray *monthArr;
    
}
@end

@implementation QuoteGalleryViewController

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    quoteDistinctArr = [[NSMutableArray alloc]init];
    viewTodayQuoteButton.layer.borderColor = squadMainColor.CGColor;//[Utility colorWithHexString:@"32CDB8"].CGColor;
    viewTodayQuoteButton.layer.borderWidth=1;
    
    quoteAllListArr = [NSMutableArray new];
    
    UINib *sectionHeaderNib = [UINib nibWithNibName:@"QuoteMonth" bundle:nil];
    [quoteMonthTable registerNib:sectionHeaderNib forHeaderFooterViewReuseIdentifier:@"QuoteMonth"];
    
    quoteSwitch.on = [defaults boolForKey:@"QuoteNotification"];
    
    //[self getLocalData];
    [self getQuoteList];
    // Do any additional setup after loading the view.
}

#pragma mark - End

#pragma mark - IBAction
-(IBAction)viewTodayQuoteButtonPressed:(id)sender{
   /* NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];//yyyy-MM-dd
    NSString *currentDateStr = [formatter stringFromDate:[NSDate date]];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(addedDate == %@)",currentDateStr];
    NSArray *filteredQuoteArray = [quoteAllListArr filteredArrayUsingPredicate:predicate];
    
    if (filteredQuoteArray.count>0) {
        NSDictionary *dict = filteredQuoteArray[0];
        QuoteViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"QuoteView"];
        controller.quoteDict = dict;
        [self.navigationController pushViewController:controller animated:YES];
    }*/
    
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"DDD"];
    int currentDayInYear = [[dateFormatter stringFromDate:currentDate] intValue];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"number == %d",currentDayInYear];
    
    NSArray *filteredQuoteArray = [[quoteAllListArr filteredArrayUsingPredicate:predicate] mutableCopy];
    
    if(![Utility isEmptyCheck:filteredQuoteArray] && filteredQuoteArray.count>0){
        
        NSDictionary *dict = filteredQuoteArray[0];
        QuoteViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"QuoteView"];
        controller.quoteDict = dict;
        [self.navigationController pushViewController:controller animated:YES];
    }
    
}
-(IBAction)quoteSwitchButtonPressed:(UISwitch*)sender{
   /* NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];//yyyy-MM-dd
    NSString *currentDateStr = [formatter stringFromDate:[NSDate date]];
    
    if (!sender.isOn) {
        NSLog(@"Off");
        quoteSwitch.on = false;
        NSArray *requests = [[UIApplication sharedApplication] scheduledLocalNotifications];
        for (UILocalNotification *req in requests) {
            NSString *pushTo = [req.userInfo objectForKey:@"pushTo"];
            if ([pushTo caseInsensitiveCompare:@"QuoteController"] == NSOrderedSame) {
                [[UIApplication sharedApplication] cancelLocalNotification:req];
            }
        }
         [defaults setObject:[NSNumber numberWithBool:false] forKey:@"QuoteNotification"];
    }else{
        NSLog(@"On");
        quoteSwitch.on = true;
        NSCalendar *theCalendar = [NSCalendar currentCalendar];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(addedDate >= %@)",currentDateStr];
        NSArray *filteredQuoteArray = [quoteAllListArr filteredArrayUsingPredicate:predicate];
        
        for (int i = 0; i < filteredQuoteArray.count; i++) {
            
            NSDate *day;
            day =  [theCalendar dateByAddingUnit:NSCalendarUnitDay
                                           value:i
                                          toDate:[NSDate date]
                                         options:0];
            
            NSDictionary *dict =filteredQuoteArray[i];
            NSString *quoteStr = [dict objectForKey:@"quoteList"];
            
            [SetReminderViewController setNotificationAt:day FromController:@"QuoteController" Id:[NSString stringWithFormat:@"id_%d",i] Title:@"Quote" Body:quoteStr];
        }
         [defaults setObject:[NSNumber numberWithBool:true] forKey:@"QuoteNotification"];
    }*/
    
    quoteSwitch.on = sender.isOn;
    
    
    if(quoteSwitch.isOn){
        [Utility cancelscheduleLocalNotificationsForQuote];
        [AppDelegate scheduleLocalNotificationsForQuote:NO];
        [defaults setBool:quoteSwitch.isOn forKey:@"QuoteNotification"];
    }else{
        
        
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"Alert!"
                                              message:@"If you turn this feature off you will no longer be sent the quote of the day"
                                              preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:@"Turn it Off"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       self->quoteSwitch.on = false;
                                       [Utility cancelscheduleLocalNotificationsForQuote];
                                       [defaults setBool:self->quoteSwitch.isOn forKey:@"QuoteNotification"];
                                   }];
        UIAlertAction *cancelAction = [UIAlertAction
                                       actionWithTitle:@"Keep it On"
                                       style:UIAlertActionStyleCancel
                                       handler:^(UIAlertAction *action)
                                       {
                                           self->quoteSwitch.on = true;
                                           [defaults setBool:self->quoteSwitch.isOn forKey:@"QuoteNotification"];
                                       }];
        
        [alertController addAction:okAction];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
    
    
}
#pragma mark - End

#pragma mark  - Private Function
-(void)getQuoteList{
    
    NSDate *quoteStartDate = [NSDate date];
    NSDate *currentDate = [NSDate date];
    
    if(![Utility isEmptyCheck:[defaults objectForKey:@"QuoteStartDate"]]){
        quoteStartDate = [defaults objectForKey:@"QuoteStartDate"];
    }else{
        [defaults setObject:quoteStartDate forKey:@"QuoteStartDate"];
    }
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"DDD"];
    
    int quoteDayInYear = [[dateFormatter stringFromDate:quoteStartDate] intValue];
    int currentDayInYear = [[dateFormatter stringFromDate:currentDate] intValue];
    
    
    NSArray *quoteArray = [Utility getQuoteListFromJSON];
    
    
    
    if(currentDayInYear < quoteDayInYear){
        NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"number >= %d",quoteDayInYear];
        NSArray *filterArray = [quoteArray filteredArrayUsingPredicate:predicate1];
        if(filterArray.count>0){
          [quoteAllListArr addObjectsFromArray:filterArray];
        }
        
        NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"number <= %d",currentDayInYear];
        NSArray *filterArray1 = [quoteArray filteredArrayUsingPredicate:predicate2];
        if(filterArray1.count>0){
            [quoteAllListArr addObjectsFromArray:filterArray1];
        }
        
        
    }else{
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"number >= %d && number <= %d",quoteDayInYear,currentDayInYear];
        
        quoteAllListArr = [[quoteArray filteredArrayUsingPredicate:predicate] mutableCopy];
    }
    
    
    
    if(![Utility isEmptyCheck:quoteAllListArr] && quoteAllListArr.count>0){
        
        quoteDistinctArr = [[quoteAllListArr valueForKeyPath:@"@distinctUnionOfObjects.addedMonth"] mutableCopy];
        [quoteMonthTable reloadData];
    }
    
    
    
    
}
-(void)getLocalData{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    monthArr =[df shortMonthSymbols];
    
    int userId = [[defaults objectForKey:@"ABBBCOnlineUserId"] intValue];
    
    if([DBQuery isRowExist:@"quoteList" condition:[@"" stringByAppendingFormat:@"UserId ='%d'",userId]]){
        
        DAOReader *dbObject = [DAOReader sharedInstance];
        if([dbObject connectionStart]){
            NSArray *arr = [dbObject selectBy:@"quoteList" withColumn:[[NSArray alloc]initWithObjects:@"UserId",@"addedDate",@"addedMonth",@"quoteList",@"favStatus",nil] whereCondition:[@"" stringByAppendingFormat:@"UserId ='%d'",userId]];
                if(arr.count>0){
                    quoteAllListArr = [arr mutableCopy];
                }
            
            [dbObject connectionEnd];
        }
    }
    NSLog(@"==%@",quoteAllListArr);
    if(![Utility isEmptyCheck:quoteAllListArr] && quoteAllListArr.count>0){
        BOOL isFlag = false;
        for (int i =0; i<monthArr.count; i++) {
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"MMM"];//yyyy-MM-dd
            NSString *currentDateStr = [formatter stringFromDate:[NSDate date]];
            
            if ([currentDateStr isEqualToString:monthArr[i]]) {
                [quoteDistinctArr addObject:currentDateStr];
                isFlag = true;
               
            }else{
                if (isFlag) {
                    [quoteDistinctArr addObject:monthArr[i]];
                }
            }
        }
        NSLog(@"=====%@",quoteDistinctArr);
        UINib *sectionHeaderNib = [UINib nibWithNibName:@"QuoteMonth" bundle:nil];
        [quoteMonthTable registerNib:sectionHeaderNib forHeaderFooterViewReuseIdentifier:@"QuoteMonth"];
        [quoteMonthTable reloadData];
    }
}
#pragma mark - End
#pragma mark - Table View Delegate and DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return quoteDistinctArr.count;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    QuoteMonth *sectionHeaderView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"QuoteMonth"];
    sectionHeaderView.monthLabel.text = [quoteDistinctArr[section] uppercaseString];
    return sectionHeaderView;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *CellIdentifier =@"QuoteTableViewCell";
    QuoteTableViewCell *cell = (QuoteTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // Configure the cell...
    if (cell == nil) {
        cell = [[QuoteTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.delegate = self;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(addedMonth == %@)",quoteDistinctArr[indexPath.section]];
    NSArray *filteredAvailableQuoteArray = [quoteAllListArr filteredArrayUsingPredicate:predicate];
    cell.quoteArr = filteredAvailableQuoteArray;
    return cell;
}
#pragma mark - End
#pragma mark - Quote Select Delegate
-(void)didSelectQuote:(NSDictionary *)quoteDict{
    QuoteViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"QuoteView"];
    controller.quoteDict = quoteDict;
    [self.navigationController pushViewController:controller animated:YES];
}
#pragma mark - End
@end
