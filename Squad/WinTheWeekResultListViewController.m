//
//  WinTheWeekResultListViewController.m
//  Squad
//
//  Created by Admin on 15/02/21.
//  Copyright © 2021 AQB Solutions. All rights reserved.
//

#import "WinTheWeekResultListViewController.h"
#import "WinTheWeekResultListTableViewCell.h"
#import "WinTheWeekViewController.h"
@interface WinTheWeekResultListViewController (){
    
    IBOutlet UILabel *headingLabel;
    IBOutlet UIButton *streakButton;
    IBOutlet UIButton *pbButton;
    IBOutlet UIButton *totalButton;
    
    IBOutlet UITableView *ListTableView;
    
    NSArray *winBracketsArray;
    
}

@end

@implementation WinTheWeekResultListViewController

@synthesize dataDict,winType;

#pragma mark - View Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    streakButton.layer.cornerRadius = streakButton.frame.size.height/2;
    streakButton.layer.masksToBounds = YES;
    streakButton.layer.backgroundColor = [Utility colorWithHexString:@"93E2DD"].CGColor;
    
    pbButton.layer.cornerRadius = pbButton.frame.size.height/2;
    pbButton.layer.masksToBounds = YES;
    pbButton.layer.backgroundColor = [Utility colorWithHexString:@"93E2DD"].CGColor;
    
    totalButton.layer.cornerRadius = totalButton.frame.size.height/2;
    totalButton.layer.masksToBounds = YES;
    totalButton.layer.backgroundColor = [Utility colorWithHexString:@"93E2DD"].CGColor;
    
    [self prepareView];
        
        
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:NO];
}

#pragma mark - End


#pragma mark - IBActions
- (IBAction)backButtonPressed:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

- (IBAction)actionButtoPressed:(UIButton *)sender {
    WinTheWeekViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"WinTheWeekView"];
    controller.winType=winType;
    controller.dayDoneCount=(int)sender.tag;
    controller.WeekStartDateStr=sender.accessibilityHint;
    controller.todayDateStr=sender.accessibilityHint;
    controller.parent=self;
    controller.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:controller animated:YES completion:nil];
}



#pragma mark - End

#pragma mark- Private Method
-(void)prepareView{
    if (![Utility isEmptyCheck:dataDict]) {
        if ([winType isEqualToString:@"DAY"]) {
            headingLabel.text=@"DAYS WON";
            [streakButton setTitle:[NSString stringWithFormat:@"%@",[dataDict objectForKey:@"CurrentDailyStreak"]] forState:UIControlStateNormal];
            [pbButton setTitle:[NSString stringWithFormat:@"%@",[dataDict objectForKey:@"PersonalBestDailyStreak"]] forState:UIControlStateNormal];
//            [totalButton setTitle:[NSString stringWithFormat:@"%d",[[dataDict objectForKey:@"CurrentDailyStreak"] intValue] + [[dataDict objectForKey:@"PersonalBestDailyStreak"] intValue] ] forState:UIControlStateNormal];
            winBracketsArray=[[NSArray alloc] initWithArray:[dataDict objectForKey:@"DailyWinBrackets"]];
        }else if ([winType isEqualToString:@"WEEK"]){
            headingLabel.text=@"WEEKS WON";
            [streakButton setTitle:[NSString stringWithFormat:@"%@",[dataDict objectForKey:@"CurrentWeeklyStreak"]] forState:UIControlStateNormal];
            [pbButton setTitle:[NSString stringWithFormat:@"%@",[dataDict objectForKey:@"PersonalBestWeeklyStreak"]] forState:UIControlStateNormal];
//            [totalButton setTitle:[NSString stringWithFormat:@"%d",[[dataDict objectForKey:@"CurrentWeeklyStreak"] intValue] + [[dataDict objectForKey:@"PersonalBestWeeklyStreak"] intValue] ] forState:UIControlStateNormal];
            winBracketsArray=[[NSArray alloc] initWithArray:[dataDict objectForKey:@"WeeklyWinBrackets"]];
        }
        
        int total=0;
        if (![Utility isEmptyCheck:winBracketsArray]) {
            for (NSDictionary *dict in winBracketsArray) {
                NSArray *bracket=[dict objectForKey:@"Brackets"];
                total=total+(int)bracket.count;
            }
            [totalButton setTitle:[NSString stringWithFormat:@"%d",total] forState:UIControlStateNormal];
        }
        
        
        [ListTableView reloadData];
    }
}

#pragma mark - End

#pragma mark -TableView Datasource & Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return winBracketsArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSDictionary *dict=[winBracketsArray objectAtIndex:section];
    NSArray *bracket=[dict objectForKey:@"Brackets"];
    return bracket.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier =@"WinTheWeekResultListTableViewCell";
    
    WinTheWeekResultListTableViewCell *cell = (WinTheWeekResultListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // Configure the cell...
    if (cell == nil) {
        cell = [[WinTheWeekResultListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSArray *brackets =[[winBracketsArray objectAtIndex:indexPath.section] objectForKey:@"Brackets"];
    NSDictionary *dict=[brackets objectAtIndex:indexPath.row];
    if (![Utility isEmptyCheck:dict]) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *weekStartDate=[formatter dateFromString:dict[@"WeekDate"]];
        NSDate *weekEndDate=[weekStartDate dateByAddingDays:6];
        [formatter setDateFormat:@"MMM"];
        NSString *monthstr=[formatter stringFromDate:weekStartDate];
        NSString *endMonthStr=[formatter stringFromDate:weekEndDate];
        [formatter setDateFormat:@"d"];
        int dayNumber=[[formatter stringFromDate:weekStartDate] intValue];
        int endDayNumber=[[formatter stringFromDate:weekEndDate] intValue];
        
        if ([winType isEqualToString:@"DAY"]) {
            cell.dateLabel.text=[NSString stringWithFormat:@"%@ %d",monthstr,dayNumber];
        }else if ([winType isEqualToString:@"WEEK"]){
            if ([monthstr isEqualToString:endMonthStr]) {
                cell.dateLabel.text=[NSString stringWithFormat:@"%@ %d-%d",monthstr,dayNumber,endDayNumber];//dayNumber+6
            }else{
                cell.dateLabel.text=[NSString stringWithFormat:@"%@ %d - %@ %d",monthstr,dayNumber,endMonthStr,endDayNumber];
            }
        }
        cell.actionButton.accessibilityHint=dict[@"WeekDate"];
        cell.actionButton.tag=[dict[@"DoneCount"] intValue];
        
        
        if (brackets.count>1) {
            NSInteger midRowval= (brackets.count/2);
            int midRow=(int)midRowval;
            if (indexPath.row==0) {
                cell.bracketMiddleView.hidden=false;
                cell.bracketTopView.hidden=true;
                cell.bracketBottomView.hidden=false;
                cell.bracketCountButton.hidden=true;
            }else if (indexPath.row==brackets.count-1){
                cell.bracketMiddleView.hidden=false;
                cell.bracketTopView.hidden=false;
                cell.bracketBottomView.hidden=true;
                cell.bracketCountButton.hidden=true;
            }else{
                cell.bracketMiddleView.hidden=true;
                cell.bracketTopView.hidden=false;
                cell.bracketBottomView.hidden=false;
                cell.bracketCountButton.hidden=true;
            }
            if (indexPath.row==midRow){
                cell.bracketCountButton.hidden=false;
                cell.bracketCountButton.layer.cornerRadius=cell.bracketCountButton.frame.size.height/2;
                cell.bracketCountButton.layer.masksToBounds = YES;
                [cell.bracketCountButton setTitle:[NSString stringWithFormat:@"%ld",brackets.count] forState:UIControlStateNormal];
            }
        }else{
            cell.bracketMiddleView.hidden=true;
            cell.bracketTopView.hidden=true;
            cell.bracketBottomView.hidden=true;
            cell.bracketCountButton.hidden=true;
        }
    }
    
    
    
    
    return cell;
        
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 43; //chayan changed
}



//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//
//}
//
//-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//
//    return 0;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//
//    return 0;
//}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma End

@end
